data "aws_ami" "this" {
  most_recent      = true
  owners           = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_vpc" "this" {
  cidr_block = "192.168.0.0/16"
  tags = {
    Name = var.identifier
  }
}

resource "aws_subnet" "pub_0" {
  availability_zone       = var.az_0
  cidr_block              = "192.168.0.0/18"
  map_public_ip_on_launch = true
  tags = {
    "kubernetes.io/cluster/${var.identifier}" = "shared"
    "kubernetes.io/role/elb" = "1"
    Name = "${var.identifier}-pub_0"
    Tier = "Public"
  }
  vpc_id                  = aws_vpc.this.id
}

resource "aws_subnet" "pub_1" {
  availability_zone = var.az_1
  cidr_block        = "192.168.64.0/18"
  map_public_ip_on_launch = true
  tags = {
    "kubernetes.io/cluster/${var.identifier}" = "shared"
    "kubernetes.io/role/elb" = "1"
    Name = "${var.identifier}-pub_1"
    Tier = "Public"
  }
  vpc_id            = aws_vpc.this.id
}

resource "aws_subnet" "priv_0" {
  availability_zone       = var.az_0
  cidr_block              = "192.168.128.0/18"
  tags = {
    "kubernetes.io/cluster/${var.identifier}" = "shared"
    "kubernetes.io/role/internal-elb" = "1"
    Name = "${var.identifier}-priv_0"
    Tier = "Private"
  }
  vpc_id                  = aws_vpc.this.id
}

resource "aws_subnet" "priv_1" {
  availability_zone = var.az_1
  cidr_block        = "192.168.192.0/18"
  tags = {
    "kubernetes.io/cluster/${var.identifier}" = "shared"
    "kubernetes.io/role/internal-elb" = "1"
    Name = "${var.identifier}-priv_1"
    Tier = "Private"
  }
  vpc_id            = aws_vpc.this.id
}

resource "aws_internet_gateway" "this" {
  tags = {
    Name = var.identifier
  }
  vpc_id = aws_vpc.this.id
}

resource "aws_eip" "pub_0" {
  depends_on = [aws_internet_gateway.this]
  tags = {
    Name = "${var.identifier}-pub_0"
  }
  vpc = true
}

resource "aws_eip" "pub_1" {
  depends_on = [aws_internet_gateway.this]
  tags = {
    Name = "${var.identifier}-pub_1"
  }
  vpc = true
}

resource "aws_nat_gateway" "pub_0" {
  allocation_id = aws_eip.pub_0.id
  subnet_id     = aws_subnet.pub_0.id
  tags = {
    Name = "${var.identifier}-pub_0"
  }
}

resource "aws_nat_gateway" "pub_1" {
  allocation_id = aws_eip.pub_1.id
  subnet_id     = aws_subnet.pub_1.id
  tags = {
    Name = "${var.identifier}-pub_1"
  }
}

resource "aws_route_table" "pub" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = {
    Name = "${var.identifier}-pub"
  }
}

resource "aws_route_table_association" "pub_0" {
  subnet_id      = aws_subnet.pub_0.id
  route_table_id = aws_route_table.pub.id
}

resource "aws_route_table_association" "pub_1" {
  subnet_id      = aws_subnet.pub_1.id
  route_table_id = aws_route_table.pub.id
}

resource "aws_route_table" "priv_0" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.pub_0.id
  }
  tags = {
    Name = "${var.identifier}-priv_0"
  }
}

resource "aws_route_table_association" "priv_0" {
  subnet_id      = aws_subnet.priv_0.id
  route_table_id = aws_route_table.priv_0.id
}

resource "aws_route_table" "priv_1" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.pub_1.id
  }
  tags = {
    Name = "${var.identifier}-priv_1"
  }
}

resource "aws_route_table_association" "priv_1" {
  subnet_id      = aws_subnet.priv_1.id
  route_table_id = aws_route_table.priv_1.id
}

resource "aws_network_acl" "this" {
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  subnet_ids = [
    aws_subnet.pub_0.id,
    aws_subnet.pub_1.id,
    aws_subnet.priv_0.id,
    aws_subnet.priv_1.id
  ] 
  tags = {
    Name = "${var.identifier}"
  }
  vpc_id     = aws_vpc.this.id
}

resource "aws_security_group" "bastion" {
  name   = "${var.identifier}-bastion"
  vpc_id = aws_vpc.this.id
}

resource "aws_security_group_rule" "bastion_ingress_all" {
  from_port         = 0
  protocol          = "-1"
  source_security_group_id = aws_security_group.bastion.id
  security_group_id = aws_security_group.bastion.id
  to_port           = 0
  type              = "ingress"
}

resource "aws_security_group_rule" "bastion_ingress_ssh" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.bastion.id
  to_port           = 22
  type              = "ingress"
}

resource "aws_security_group_rule" "bastion_egress" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.bastion.id
  to_port           = 0
  type              = "egress"
}

resource "aws_instance" "this" {
  ami                    = data.aws_ami.this.id
  instance_type          = "t3.micro"
  key_name               = var.key_name
  subnet_id              = aws_subnet.pub_0.id
  tags = {
    Name = "${var.identifier}-bastion"
  }
  vpc_security_group_ids = [aws_security_group.bastion.id]
}

