import json
from app import *
from models import DBconn
from flask.ext.httpauth import HTTPBasicAuth
from flask import request
import re
import hashlib
from flask import jsonify
from spcalls import SPcalls


def store_user(data):

    # data = json.loads(request.data)
    # print "my data is ", data
    username = data['username']
    email = data['email']
    spcalls = SPcalls()
    print "spcall", spcalls

    check_username_exist = spcalls.spcall('check_username', (username,))
    print "check_username_exist", str(check_username_exist[0][0])

    check_email_exist = spcalls.spcall('check_mail', (email,))
    print "check_email_exist", str(check_email_exist[0][0])

    if check_username_exist[0][0] == 'OK' and check_email_exist[0][0] == 'OK':

        check_mail = re.match('^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$', email)
        print "check_mail", check_mail

        if check_mail is not None:
            fname = data['fname']
            mname = data['mname']
            lname = data['lname']
            password = data['password']
            role_id = data['role_id']

            if fname != '' and mname != '' and lname != '' and username != '' and password != '' and role_id != None:
                """
                PASSWORD HASHING
                source: https://pythonprogramming.net/password-hashing-flask-tutorial/

                import hashlib
                password = 'pa$$w0rd'
                h = hashlib.md5(password.encode())
                print(h.hexdigest())

                """
                pw_hash = hashlib.md5(password.encode())

                store_user = spcalls.spcall('store_user', (fname, mname, lname, username, pw_hash.hexdigest(), email, role_id), True )

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

