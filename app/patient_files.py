import json
from app import *
from models import DBconn
from flask.ext.httpauth import HTTPBasicAuth
from flask import request
import re
import hashlib
from flask import jsonify
from spcalls import SPcalls
from assessments import *

spcalls = SPcalls()


def store_patient(school_id, data):
    school_id_exists = spcalls.spcall('school_id_exists', (school_id,), True)

    def names_empty(fname, mname, lname):
        if not school_id or not fname  or not mname or not lname :
            return False
        else:
            return True

    def bio_empty(age, sex, height, weight, date_of_birth):
        if not age or not sex or not height or not weight or not date_of_birth:
            return False
        else:
            return True

    def extra_info_empty(department_id, patient_id, civil_status, name_of_guardian, home_address):
        if not department_id or not patient_id or civil_status == '' or name_of_guardian == '' \
                or home_address == '':
            return False
        else:
            return True

    def valid_patient_info(patient):
        fname = patient['fname']
        mname = patient['mname']
        lname = patient['lname']
        age = patient['age']
        sex = patient['sex']
        department_id = patient['department_id']
        patient_id = patient['patient_type_id']
        height = patient['height']
        weight = patient['weight']
        date_of_birth = patient['date_of_birth']
        civil_status = patient['civil_status']
        name_of_guardian = patient['name_of_guardian']
        home_address = patient['home_address']

        empty_names = names_empty(fname, mname, lname)
        empty_bio = bio_empty(age, sex, height, weight, date_of_birth)
        empty_extra_info = extra_info_empty(department_id, patient_id, civil_status, name_of_guardian, home_address)

        print "empty_names", empty_names
        print "empty_bio", empty_bio
        print "empty_extra_info", empty_extra_info

        empty_fields =  empty_names and empty_bio and empty_extra_info

        if empty_fields is True:
            return True
        else:
            return False    

    def valid_patient_history(history):

        smoking = history['smoking']
        allergies = history['allergies']
        alcohol = history['alcohol']
        medications_taken = history['medications_taken']
        drugs = history['drugs']

        empty_fields = not school_id or not smoking or not allergies or not alcohol or not medications_taken or not drugs

        if empty_fields is True:
            return False

        else:
            return True

    def store_patient_info():

        store_new_patient = spcalls.spcall('new_store_patient',
                                           (school_id,
                                            data['fname'],
                                            data['mname'],
                                            data['lname'],
                                            data['age'],
                                            data['sex'],
                                            int(data['department_id']),
                                            int(data['patient_type_id']),
                                            data['height'],
                                            data['weight'],
                                            data['date_of_birth'],
                                            data['civil_status'],
                                            data['name_of_guardian'],
                                            data['home_address']), True)

        return store_new_patient[0][0]

    def store_patient_history():

        store_new_history = spcalls.spcall('new_patient_history',
                                           (school_id, data['smoking'], data['allergies'],
                                            data['alcohol'], data['medications_taken'],
                                            data['drugs']), True)

        return store_new_history[0][0]

    def store_pulmonary():

        store_new_pulmonary = spcalls.spcall('new_pulmonary',
                                             (school_id,
                                              data['cough'],
                                              data['dyspnea'],
                                              data['hemoptysis'],
                                              data['tb_exposure']), True)

        return store_new_pulmonary[0][0]

    def store_gut():

        store_new_gut = spcalls.spcall('new_gut',
                                       (school_id,
                                        data['frequency'],
                                        data['flank_plan'],
                                        data['discharge'],
                                        data['dysuria'],
                                        data['nocturia'],
                                        data['dec_urine_amount']), True)

        return store_new_gut[0][0]

    def store_illness():

        store_new_illness = spcalls.spcall('new_illness',
                                           (school_id,
                                            data['asthma'],
                                            data['ptb'],
                                            data['heart_problem'],
                                            data['hepatitis_a_b'],
                                            data['chicken_pox'],
                                            data['mumps'],
                                            data['typhoid_fever']), True)

        return store_new_illness[0][0]

    def store_cardiac():

        store_new_cardiac = spcalls.spcall('new_cardiac',
                                           (school_id,
                                            data['chest_pain'],
                                            data['palpitations'],
                                            data['pedal_edema'],
                                            data['orthopnea'],
                                            data['nocturnal_dyspnea']), True)

        return store_new_cardiac[0][0]

    def store_neurologic():

        store_new_neurologic = spcalls.spcall('new_neurologic',
                                              (school_id,
                                               data['headache'],
                                               data['seizure'],
                                               data['dizziness'],
                                               data['loss_of_consciousness']), True)

        return store_new_neurologic[0][0]


    valid_data = valid_patient_info(data) and valid_patient_history(data)

    validity = school_id_exists[0][0] == 'f' and valid_data is True

    if school_id_exists[0][0] == 'f' and valid_data is True:
        store_patient_info()
        store_patient_history()
        store_pulmonary()
        store_gut()
        store_illness()
        store_cardiac()
        store_neurologic()
        return jsonify({'status': 'OK', 'message': 'Successfully added new patient'})
    
    elif school_id_exists[0][0] == 'f' and valid_data is False:
        return jsonify({'status': 'FAILED', 'message': 'Please type correct inputs'})

    elif school_id_exists[0][0] == 't' and valid_data is True:
        return jsonify({'status': 'FAILED', 'message': 'School ID already exists'})

    elif school_id_exists[0][0] == 't' and valid_data is False:
        return jsonify({'status': 'FAILED', 'message': 'School ID already exists'})

    else:
        return jsonify({'status': 'FAILED', 'message': 'ERROR', 's': str(school_id_exists[0][0]), 'v':str(valid_data)})


def show_patient(school_id):
    patient_info = spcalls.spcall('show_patient_info',(school_id, ))
    patient_history = spcalls.spcall('show_patient_history',(school_id, ))
    pulmonary = spcalls.spcall('show_pulmonary',(school_id, ))
    gut = spcalls.spcall('show_gut',(school_id, ))
    illness = spcalls.spcall('show_illness',(school_id, ))
    cardiac = spcalls.spcall('show_cardiac',(school_id, ))
    neurologic = spcalls.spcall('show_neurologic',(school_id, ))

    entries = []

    check_schoolID_exists = check_schoolID(school_id)

    if not school_id:
        return jsonify({"status": "FAILED", "message": "Please input school ID."})

    elif check_schoolID_exists == 'f':
        return jsonify({"status": "FAILED", "message": "School ID does not exist."})

    elif 'Error' in str(patient_info[0][0]):
        return jsonify({"status": "FAILED", "message": patient_info[0][0]})

    elif 'Error' in str(patient_history[0][0]):
        return jsonify({"status": "FAILED", "message": patient_history[0][0]})

    elif 'Error' in str(pulmonary[0][0]):
        return jsonify({"status": "FAILED", "message": pulmonary[0][0]})

    elif 'Error' in str(gut[0][0]):
        return jsonify({"status": "FAILED", "message": gut[0][0]})

    elif 'Error' in str(illness[0][0]):
        return jsonify({"status": "FAILED", "message": illness[0][0]})

    elif 'Error' in str(cardiac[0][0]):
        return jsonify({"status": "FAILED", "message": cardiac[0][0]})

    elif 'Error' in str(neurologic[0][0]):
        return jsonify({"status": "FAILED", "message": neurologic[0][0]})

    elif len(patient_info) != 0 or len(patient_history) != 0:
        for r in patient_info:
            entries.append({
                "school_id" : r[0],
                "fname": r[1],
                "mname": r[2],
                "lname": r[3],
                "age": r[4],
                "sex": r[5],
                "dept_id": r[6],
                "ptnt_id": r[7],
                "height": r[8],
                "weight": r[9],
                "date_of_birth": r[10],
                "civil_status": r[11],
                "guardian": r[12],
                "home_addr": r[13],
            })

        for r in patient_history:
            entries.append({
                "smoking": r[1],
                "allergies": r[2],
                "alcohol": r[3],
                "medications_taken": r[4],
                "drugs": r[5]
            })

        for r in pulmonary:
            entries.append({
                "cough": r[1],
                "dyspnea": r[2],
                "hemoptysis": r[3],
                "tb_exposure": r[4],
            })

        for r in gut:
            entries.append({
                "frequency": r[1],
                "flank_plan": r[2],
                "discharge": r[3],
                "dysuria": r[4],
                "nocturia": r[5],
                "dec_urine_amount": r[6]
            })

        for r in illness:
            entries.append({
                "asthma": r[1],
                "ptb": r[2],
                "heart_problem": r[3],
                "hepa_a_b": r[4],
                "chicken_pox": r[5],
                "mumps": r[6],
                "typhoid_fever": r[7]
            })

        for r in cardiac:
            entries.append({
                "chest_pain": r[1],
                "palpitations": r[2],
                "pedal_edema": r[3],
                "orthopnea": r[4],
                "nocturnal_dyspnea": r[5]
            })

        for r in neurologic:
            entries.append({
                "headache": r[1],
                "seizure": r[2],
                "dizziness": r[3],
                "loss_of_consciousness": r[4]
            })

        return jsonify({"status": "OK", "message": "OK", "entries": entries})

    else:
        return jsonify({"status": "FAILED", "message": "No Patient File Found", "entries": []})


def show_all_colleges():
    colleges = spcalls.spcall('show_all_colleges',())
    entries = []

    if 'Error' in str(colleges[0][0]):
        return jsonify({"status": "FAILED", "message": colleges[0][0]})

    elif len(colleges) != 0:
        for college in colleges:
            entries.append({"id": college[0],
                            "college_name": college[1]
                            })

        return jsonify({"status": "OK", "message": "OK", "entries": entries, "count": len(entries)})

    else:
        return jsonify({"status": "FAILED", "message": "No College Found", "entries": []})