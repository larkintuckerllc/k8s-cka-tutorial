# pylint: disable=no-member
from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello():
    return 'hello world'

