provider "aws" {
  region = "us-east-1"
}

data "aws_region" "this" {
}

locals {
  az_0       = "us-east-1a"
  az_1       = "us-east-1b"
  identifier = "k8s-cka-tutorial"
}

module "vpc" {
  source = "./modules/vpc"
  az_0       = local.az_0
  az_1       = local.az_1
  identifier = local.identifier
  key_name   = var.key_name
}

# ROLES

resource "aws_iam_role" "eks_cluster" {
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
  name               = "${local.identifier}-eksClusterRole"
}

resource "aws_iam_role_policy_attachment" "eks_cluster" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.id
}

resource "aws_iam_role" "node_instance" {
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
  name               = "${local.identifier}-NodeInstanceRole"
}

resource "aws_iam_role_policy_attachment" "node_instance_worker" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node_instance.id
}

resource "aws_iam_role_policy_attachment" "node_instance_cni" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node_instance.id
}

resource "aws_iam_role_policy_attachment" "node_instance_registry" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node_instance.id
}

# SECURITY GROUPS

resource "aws_security_group" "control_plane" {
  name   = "${local.identifier}-ControlPlaneSecurityGroup"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "control_plane" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.control_plane.id
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group" "remote_access" {
  name   = "${local.identifier}-remoteAccess"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "remote_access_ingress" {
  from_port                = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.remote_access.id
  source_security_group_id = module.vpc.bastion_security_group_id
  to_port                  = 22
  type                     = "ingress"
}

resource "aws_security_group_rule" "remote_access_egress" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.remote_access.id
  to_port           = 0
  type              = "egress"
}

# CLUSTER RESOURCES

resource "aws_eks_cluster" "this" {
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster
  ]
  name     = local.identifier
  role_arn = aws_iam_role.eks_cluster.arn
  vpc_config {
    security_group_ids = [
      aws_security_group.control_plane.id
    ]
    subnet_ids = module.vpc.subnet_ids
  }
}

resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  depends_on = [
    aws_iam_role_policy_attachment.node_instance_worker,
    aws_iam_role_policy_attachment.node_instance_cni,
    aws_iam_role_policy_attachment.node_instance_registry
  ]
  node_group_name = local.identifier
  node_role_arn   = aws_iam_role.node_instance.arn
  remote_access {
    ec2_ssh_key = var.key_name
    source_security_group_ids = [module.vpc.bastion_security_group_id]
  }
  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 2
  }
  subnet_ids      = module.vpc.private_subnet_ids
  tags = {
    Name = local.identifier
  }
}
