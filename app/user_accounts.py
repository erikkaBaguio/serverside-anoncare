import json
from app import *
from models import DBconn
from flask.ext.httpauth import HTTPBasicAuth
from flask import request
import re
import hashlib
from flask import jsonify
from send_mail import *
from spcalls import SPcalls
import random
import string


spcalls = SPcalls()


def check_username(username):
    check_response = spcalls.spcall('check_username', (username,))

    return check_response

def username_checker(username):
    response = check_username(username)

    if response == 'f':
        return jsonify({"status": "FAILED", "message": "Username does not exists"})

    else:
        return jsonify({"status": "OK", "message": "Username already exists"})

def store_user(data):

    username = data['username']
    email = data['email']

    print "spcall", spcalls

    check_username_exist = spcalls.spcall('check_username', (username,))

    check_email_exist = spcalls.spcall('check_mail', (email,))

    if check_username_exist[0][0] == 'OK' and check_email_exist[0][0] == 'OK':

        check_mail = re.match('^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$', email)

        if check_mail is not None:
            fname = data['fname']
            mname = data['mname']
            lname = data['lname']
            password = data['password']
            role_id = data['role_id']

            if fname is not '' and mname is not '' and lname is not '' and username is not '' and password is not '' and role_id is not None:
                """
                PASSWORD HASHING
                source: https://pythonprogramming.net/password-hashing-flask-tutorial/

                import hashlib
                password = 'pa$$w0rd'
                h = hashlib.md5(password.encode())
                print(h.hexdigest())

                """
                pw_hash = hashlib.md5(password.encode())

                store_user = spcalls.spcall('store_user', (fname, mname, lname, username, pw_hash.hexdigest(), email, role_id), True)

                if store_user[0][0] == 'OK':
                    sent = send_email(data['username'], data['email'], data['password'])

                    return jsonify({"status": 'OK', 'message': 'Successfully add ' + str(fname)})

                elif store_user[0][0] == 'Error':
                    return jsonify({'status': 'FAILED', 'message': 'failed to add ' + str(fname)})

                else:
                    return jsonify({'status': '404'})

            else:
                return jsonify({'status': 'FAILED', 'message': 'Please input required fields!'})

        else:
            return jsonify({'status': 'FAILED', 'message': 'Invalid email input!'})

    elif check_username_exist[0][0] == 'EXISTED':
        return jsonify({'status ': 'FAILED', 'message': 'username already exist'})

    elif check_email_exist[0][0] == 'EXISTED':
        return jsonify({'status ': 'FAILED', 'message': 'email already exist'})

    else:
        return jsonify({'failed': 'FAILED'})


def show_user_id(id):
    spcalls = SPcalls()
    print "spcall", spcalls
    #when you have only one parameter you need to user "," comma.
    #example: spcals('show_user_id', (id,) )
    user_id = spcalls.spcall('show_user_id', (id,))
    data = []

    if len(user_id) == 0:
        return jsonify({"status": "FAILED", "message": "No User Found", "entries": []})

    else:
        r = user_id[0]
        data.append({"fname": r[0],
                     "mname":r[1],
                     "lname":r[2],
                     "email":r[3],
                     "username":r[4],
                     "role_id":r[5]})
        return jsonify({"status": "OK", "message": "OK", "entries": data})


def show_all_users():
    records = spcalls.spcall('show_all_users',())
    print "records", records
    entries = []

    if 'Error' in str(records[0][0]):
        return jsonify({'status': 'error', 'message': records[0][0]})

    elif len(records) != 0:
        for row in records:
            entries.append({
                "fname": row[0],
                "mname": row[1],
                "lname": row[2],
                "email": row[4],
                "username": row[3],
                "role_id": row[5]
            })

        return jsonify({"status": "OK", "message":"OK", "entries":entries, "count": len(entries)})

    else:
        return jsonify({"status": 'OK', "message": "No Users Found"})


def search_user(data):
    keyword = data['search']
    users = spcalls.spcall('search_user', (keyword,) )

    data = []

    if users:

        for u in users:
            data.append({'fname':u[0], 'mname':u[1], 'lname':u[2], 'email':u[3], 'role':u[5]})

        return jsonify({'status':'OK', 'message':'This are all the user(s) matched your search ', 'data':data})

    return jsonify({'status':'FAILED', 'message':'No data matched your search'})


def change_password(username, password):

    pw_hash = hashlib.md5(password.encode())

    spcalls.spcall("updatepassword", (username, pw_hash.hexdigest(),), True)

    return jsonify({"status": "OK", "message": "Password Changed!"})


def get_username(email):

    data = spcalls.spcall("show_user_email", (email,))

    username = data[0][4]

    return username


def generate_password():
    characters = string.letters + string.digits + string.punctuation
    pwd_size = 20

    new_password = ''.join((random.choice(characters)) for x in range(pwd_size))

    print "characters", characters
    print "new_password", new_password

    return new_password


def login_forgot_password(email):
    check_email_exist = spcalls.spcall('check_mail', (email,))

    if check_email_exist[0][0] == 'EXISTED':

        username = get_username(email)
        new_password = generate_password()

        password_change = change_password(username, new_password)

        send_mail = forgot_pass_send_email(email, new_password)

        return password_change

    else:
        return jsonify({"status": "ERROR", "message": "No Email Exists"})
