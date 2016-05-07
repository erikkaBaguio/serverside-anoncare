import os
from flask import Flask, jsonify, request, session, redirect, url_for
from os import sys
from models import DBconn
import json, flask
from app import *
import re                   #this is for verifying if the email is valid
import hashlib
from flask.ext.httpauth import HTTPBasicAuth
from user_accounts import *
from patient_files import *
from spcalls import SPcalls


auth = HTTPBasicAuth()
spcall = SPcalls()

@app.route('/')
# @auth.login_required
def index2():
    return 'Hello world!'


@auth.get_password
def get_password(username):
    return spcall.spcall('get_password', (username,))[0][0]


@app.route('/api/anoncare/user', methods=['POST'])
def store_new_user():
    data = json.loads(request.data)
    print 'data is', data

    dictlist = []

    for key, value in data.iteritems():
        temp = [key, value]
        dictlist.append(value)

    dictlist = str(dictlist)

    print "dictlist", dictlist

    add_user = store_user(data)

    return add_user


@app.route('/api/anoncare/patient', methods=['POST'])
def store_patient():
    data = json.loads(request.data)
    print "data is", data
    school_id = data['school_id']

    new_patient = store_patient_info(school_id, data)
    patient_history = store_patient_history(school_id, data)

    returns = [new_patient, patient_history]

    print "new_patient, patient_history", returns

    return jsonify({'new_patient': returns})
    # return new_patient, patient_history


@app.route('/api/anoncare/user', methods = ['GET'])
def show_users():

    users = show_all_users()

    return users


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