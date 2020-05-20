# pylint: disable=no-member
from flask import abort, Flask, request, Response
from flask_cors import CORS
import json
from os import getenv
import redis
from uuid import uuid4

redis_url = getenv('REDIS_URL')
redis_client = redis.Redis.from_url(redis_url)

def to_todo(key):
    id = key.decode('utf-8')
    value = redis_client.get(id)
    name = value.decode('utf-8')
    todo = {
        'Id': id,
        'Name': name
    }
    return todo

class NotFoundException(Exception):
    pass

app = Flask(__name__)
CORS(app)

@app.route('/probe')
def probe():
    try:
        redis_client.execute_command('INFO')
        return 'success'
    except:
        abort(500)

@app.route('/todos')
def read():
    # HACK: this use of Redis not suitable for production
    try:
        keys = redis_client.keys() 
        todos = list(map(to_todo, keys))
        todos_json = json.dumps(todos)
        return Response(todos_json, mimetype='application/json')
    except:
        abort(500)

@app.route('/todos', methods=['POST'])
def create():
    request_dict = request.json
    if request_dict == None:
        abort(400)
        return
    if not 'Name' in request_dict:
        abort(400)
        return
    name = request_dict['Name']
    if not isinstance(name, str):
        abort(400)
        return
    try:
        id = str(uuid4())
        redis_client.set(id, name)
        item = {
            'Id': id,
            'Name': name
        }
        return item
    except:
        abort(500)

@app.route('/todos/<id>', methods=['DELETE'])
def delete(id):
    try:
        value = redis_client.get(id)
        if value == None:
            raise NotFoundException()    
        redis_client.delete(id)
        id = {
            'Id': id
        }
        return id
    except NotFoundException as e:
        abort(404)
    except:
        abort(500)
