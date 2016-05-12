import os
from flask import Flask, jsonify, request
from os import sys
from models import DBconn
import json, flask
from app import app
import re  # this is for verifying if the email is valid
import hashlib
from flask.ext.httpauth import HTTPBasicAuth
from user_accounts import *
from patient_files import *
from assessments import *
from send_mail import *
from spcalls import SPcalls
from datetime import timedelta
from itsdangerous import URLSafeTimedSerializer
from flask_mail import Mail

SECRET_KEY = "a_random_secret_key_$%#!@"
auth = HTTPBasicAuth()

# Login_serializer used to encryt and decrypt the cookie token for the remember
# me option of flask-login
login_serializer = URLSafeTimedSerializer(SECRET_KEY)

# mail = Mail(app)

# app.config.update(
#     MAIL_SERVER='smtp.gmail.com',
#     MAIL_PORT=465,
#     MAIL_USE_SSL=True,
#     MAIL_USERNAME='anoncare.iit@gmail.com',
#     MAIL_PASSWORD='anoncareiit',
#
#     )

app.config.update(DEBUG=True,
                  MAIL_SERVER='smtp.gmail.com',
                  MAIL_PORT=587,
                  MAIL_USE_SSL=False,
                  MAIL_USE_TLS=True,
                  MAIL_USERNAME='anoncare.iit@gmail.com',
                  MAIL_PASSWORD='anoncareiit'
                  )
#
# app.config['MAIL_SERVER'] = 'smtp.gmail.com',
# app.config['MAIL_PORT'] = 465,
# app.config['MAIL_USE_SSL'] = True,
# app.config['MAIL_USERNAME'] = 'anoncare.iit@gmail.com',
# app.config['MAIL_PASSWORD'] = 'anoncareiit',

mail = Mail(app)


def get_auth_token(username, password):
    """
    Encode a secure token for cookie
    """
    data = [username, password]
    return login_serializer.dumps(data)


def load_token(token):
    """

    The Token was encrypted using itsdangerous.URLSafeTimedSerializer which
    allows us to have a max_age on the token itself.  When the cookie is stored
    on the users computer it also has a exipry date, but could be changed by
    the user, so this feature allows us to enforce the exipry date of the token
    server side and not rely on the users cookie to exipre.

    source: http://thecircuitnerd.com/flask-login-tokens/
    """
    days = timedelta(days=14)
    max_age = days.total_seconds()

    # Decrypt the Security Token, data = [username, hashpass]
    data = login_serializer.loads(token, max_age=max_age)

    return data[0] + ':' + data[1]


@auth.get_password
def get_password(username):
    spcall = SPcalls()
    return spcall.spcall('get_password', (username,))[0][0]


@app.route('/decrypt', methods=['POST'])
def decr():
    credentials = json.loads(request.data)
    token = credentials['token']

    print token

    return jsonify({'status': 'OK', 'token': load_token(token)})


@app.route('/auth', methods=['POST'])
def authentication():
    credentials = json.loads(request.data)
    username = credentials['username']
    password = credentials['password']

    spcall = SPcalls()

    get_user = spcall.spcall('check_username_password', (username, password))

    if (get_user[0][0] == 'FAILED'):
        return jsonify({'status': 'FAILED', 'message': 'Invalid username or password'})

    if (get_user[0][0] == 'OK'):

        user = spcall.spcall('show_user_username', (username,))
        data = []

        for u in user:
            data.append({'fname': u[0], 'mname': u[1], 'lname': u[2], 'email': u[3], 'role': u[5]})

        token = get_auth_token(username, password)

        return jsonify({'status': 'OK', 'message': 'Successfully logged in', 'token': token, 'data': data})

    else:
        return jsonify({'status': 'ERROR', 'message': '404'})


@app.route('/api/anoncare/home/<string:token>', methods=['GET'])
@auth.login_required
def index(token):
    days = timedelta(days=14)
    max_age = days.total_seconds()
    # Decrypt the Security Token, data = [username, hashpass]
    username = login_serializer.loads(token, max_age=max_age)
    spcall = SPcalls()

    user = spcall.spcall('show_user_username', (username[0],))
    data = []

    for u in user:
        data.append({'fname': u[0], 'mname': u[1], 'lname': u[2], 'email': u[3], 'role': u[5]})

    print data[0]
    return jsonify({'status': 'OK', 'message': 'Welcome user', 'data': data})


def send_email(username, email, password):
    msg = Message(
        'AnonCare Registration',
        sender='anoncare.iit@gmail.com',
        recipients=[email]
    )

    msg.body = "Username is: " + username + "\n" \
                + "Password is: " + password
    mail.send(msg)

    return "Sent"


@app.route('/api/anoncare/user', methods=['POST'])
@auth.login_required
def store_new_user():
    data = json.loads(request.data)
    print 'data is', data

    add_user = store_user(data)

    sent = send_mail(data['username'], data['email'], data['password'])
    print "sent", sent

    return add_user


@app.route('/api/anoncare/user/<int:id>/', methods=['GET'])
def show_userId(id):
    get_user = show_user_id(id)

    return get_user


@app.route('/api/anoncare/patient', methods=['POST'])
@auth.login_required
def store_new_patient():
    data = json.loads(request.data)
    print "data is", data
    school_id = data['school_id']

    new_patient = store_patient(school_id, data)

    return new_patient


@app.route('/api/anoncare/user', methods=['GET'])
@auth.login_required
def show_users():
    users = show_all_users()

    return users


@app.route('/api/anoncare/password_reset/<string:token>', methods=['POST'])
def password_reset(token):
    data = json.loads(request.data)

    days = timedelta(days=14)
    max_age = days.total_seconds()

    print "token", token

    token = login_serializer.loads(token, max_age=max_age)

    username = token[0]

    print "username", username

    new_password = data['password']

    reset = reset_password(username, new_password)

    return reset


@app.route('/api/anoncare/user/search', methods=['POST'])
@auth.login_required
def search_users():
    return search_user(json.loads(request.data))


@app.route('/api/anoncare/assessment/<int:school_id>/<int:assessment_id>/', methods=['GET'])
def show_assessmentId(school_id, assessment_id):
    get_assessment_id = show_assessment_id(school_id, assessment_id)

    return get_assessment_id


@app.route('/api/anoncare/assessment/<int:school_id>')
def show_assessment(school_id):
    return show_assessment(school_id)


@app.route('/api/anoncare/assessment', methods=['POST'])
def add_assessments():
    data = json.loads(request.data)

    assessment = store_assessment(data)

    return assessment


@app.route('/api/anoncare/school_id_exists/<int:school_id>/', methods=['GET'])
def check_schoolID_exists(school_id):
    school_id_exists = jsonify_check_schoolID(school_id)

    return school_id_exists


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
