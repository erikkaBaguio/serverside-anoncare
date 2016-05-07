import json
from app import *
from models import DBconn
from flask.ext.httpauth import HTTPBasicAuth
from flask import request
import re
import hashlib
from flask import jsonify
from spcalls import SPcalls

spcalls = SPcalls()

def store_user(data):

    # data = json.loads(request.data)
    # print "my data is ", data
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
                    return jsonify({'status': 'OK', 'message': 'Successfully add ' + str(fname)})

                elif store_user[0][0] == 'Error':
                    return jsonify({'status': 'failed', 'message': 'failed to add ' + str(fname)})

                else:
                    return jsonify({'ERROR': '404'})

            else:
                return jsonify({'status': 'failed', 'message': 'Please input required fields!'})

        else:
            return jsonify({'status': 'failed', 'message': 'Invalid email input!'})

    elif check_username_exist[0][0] == 'EXISTED':
        return jsonify({'status ': 'failed', 'message': 'username already exist'})

    elif check_email_exist[0][0] == 'EXISTED':
        return jsonify({'status ': 'failed', 'message': 'email already exist'})

    else:
        return jsonify({'failed': 'failed'})


    def show_all_users():
        users = spcalls.spcall('show_all_users',())
        entries = []

        if 'Error' in str(users[0][0]):
            return jsonify({'status': 'error', 'message': users[0][0]})

        elif len(users) != 0:
            row = users[0]
            entries.append({
                "fname":  row[0],
                "mname": row[1],
                "lname": row[2],
                "email": row[3],
                "username": row[4],
                "role_id": row[6]
            })

            return jsonify({"status": "OK", "message":"OK", "entires":entries, "count": len(entries)})

        else:
            return jsonify({"status": 'OK', "message": "No Users Found"})


