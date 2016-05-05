import os
from flask import Flask, jsonify, request, session, redirect, url_for
from os import sys
from models import DBconn
import json, flask
from app import *
import re                   #this is for verifying if the email is valid
import hashlib
from flask.ext.httpauth import HTTPBasicAuth
from user_accounts import store_user
from spcalls import SPcalls


auth = HTTPBasicAuth()


@app.route('/')
# @auth.login_required
def index2():
    return 'Hello world!'


@auth.get_password
def get_password(username):
    spcall = SPcalls()
    return spcall.spcall('get_password', (username,))[0][0]


@app.route('/api/anoncare/user', methods=['POST'])
def storeuser():
    data = json.loads(request.data)
    # print 'data is', data

    add_user = store_user(data)
    print "add_user", add_user

    return add_user



@app.after_request
def add_cors(resp):
    resp.headers['Access-Control-Allow-Origin'] = flask.request.headers.get('Origin', '*')
    resp.headers['Access-Control-Allow-Credentials'] = True
    resp.headers['Access-Control-Allow-Methods'] = 'POST, OPTIONS, GET, PUT, DELETE'
    resp.headers['Access-Control-Allow-Headers'] = flask.request.headers.get('Access-Control-Request-Headers',
                                                                             'Authorization')
    # set low for debugging
    if app.debug:
        resp.headers["Access-Control-Max-Age"] = '1'
    return resp