#! /usr/bin/env python
"""
Simple application to provide a REST API
"""

from flask import Flask, jsonify, request, abort
from flask_cors import CORS

app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}}, send_wildcard=True)

@app.route('/example/api/users', methods=['GET'])
def get_users():
    data = {"name" : "Jo",
            "email" : "Jo@example.org",
            "community" : "Example Corp",
            "tosArgeement" : "Ok"
            }
    return jsonify(data)

@app.route('/example/api/users', methods=['POST'])
def post_users():
    if not request.json:
        abort(400)
    print("request ", request.json)
    return jsonify({"result":"data received"})

if __name__ == '__main__':
    app.run(debug=True)
