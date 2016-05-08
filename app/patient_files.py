import json
from app import *
from models import DBconn
from flask.ext.httpauth import HTTPBasicAuth
from flask import request
import re
import hashlib
from flask import jsonify
from spcalls import SPcalls


# def get_school_id():
#     data = json.loads(request.data)
#     school_id = data['school_id']
#
#     return school_id

def names_empty(fname, mname, lname):
    if fname is '' or mname is '' or lname is '':
        return True
    else:
        return False


def bio_empty(age, sex, height, weight, date_of_birth):
    if age is None or sex is '' or height is '' or weight is None or date_of_birth is '':
        return True
    else:
        return False


def extra_info_empty(dept_id, ptnt_id, civil_status, name_of_guardian, home_addr):
    if dept_id is None or ptnt_id is None or civil_status is '' or name_of_guardian is '' or home_addr is '':
        return True
    else:
        return False


def store_patient_info(school_id, patient):
    spcalls = SPcalls()

    fname = patient['fname']
    mname = patient['mname']
    lname = patient['lname']
    age = patient['age']
    sex = patient['sex']
    dept_id = patient['department_id']
    ptnt_id = patient['patient_type_id']
    height = patient['height']
    weight = patient['weight']
    date_of_birth = patient['date_of_birth']
    civil_status = patient['civil_status']
    guardian = patient['name_of_guardian']
    home_addr = patient['home_address']

    empty_names = names_empty(fname, mname, lname)
    empty_bio = bio_empty(age, sex, height, weight, date_of_birth)
    empty_extra_info = extra_info_empty(dept_id, ptnt_id, civil_status, guardian, home_addr)

    empty_fields = empty_names and empty_bio and empty_extra_info
    print "empty_fields", empty_fields

    if empty_fields is False:
        store_patient = spcalls.spcall('new_store_patient', (school_id, fname, mname, lname, age, sex, dept_id,
                                                             ptnt_id, height, weight, date_of_birth, civil_status, guardian, home_addr), True)

        print "store_patient[0][0]", store_patient[0][0]

        if store_patient[0][0] == 'OK':
            return jsonify({'status': 'OK', 'message': 'Successfully add ' + str(fname)})

        elif store_patient[0][0] == 'Error':
            return jsonify({'status': 'failed', 'message': 'failed to add ' + str(fname)})

        else:
            return jsonify({'ERROR': '404'})

    else:
            return jsonify({'status': 'failed', 'message': 'Please input required fields!'})


def store_patient_history(school_id, history):
    spcalls = SPcalls()

    smoking = history['smoking']
    allergies = history['allergies']
    alcohol = history['alcohol']
    medications_taken = history['medications_taken']
    drugs = history['drugs']

    empty_fields = smoking is '' or allergies is '' or alcohol is '' or medications_taken is '' or drugs is ''

    if empty_fields is False:
        store_patient = spcalls.spcall('new_patient_history', (school_id, smoking, allergies, alcohol, medications_taken, drugs), True)

        print "store_patient[0][0]", store_patient[0][0]

        if store_patient[0][0] == 'OK':
            return jsonify({'status': 'OK', 'message': 'Successfully add history'})

        elif store_patient[0][0] == 'Error':
            return jsonify({'status': 'failed', 'message': 'failed to add history'})

        else:
            return jsonify({'ERROR': '404'})

    else:
            return jsonify({'status': 'failed', 'message': 'Please input required fields!'})