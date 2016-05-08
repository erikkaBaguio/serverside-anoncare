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

def store_patient(school_id, data):

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
                                                             ptnt_id, height, weight, date_of_birth, civil_status,
                                                             guardian, home_addr), True)

            if store_patient[0][0] == 'OK':
                return jsonify({'status': 'OK', 'message': 'Successfully add ' + str(fname)})

            elif store_patient[0][0] == 'Error':
                return jsonify({'status': 'failed', 'message': 'failed to add ' + str(fname)})

            else:
                return jsonify({'ERROR': '404'})

        else:
            return jsonify({'status': 'failed', 'message': 'Please input required fields!'})


    def store_patient_history(school_id, history):
        smoking = history['smoking']
        allergies = history['allergies']
        alcohol = history['alcohol']
        medications_taken = history['medications_taken']
        drugs = history['drugs']

        empty_fields = smoking is '' or allergies is '' or alcohol is '' or medications_taken is '' or drugs is ''

        if empty_fields is False:
            store_history = spcalls.spcall('new_patient_history',
                                               (school_id, smoking, allergies, alcohol, medications_taken, drugs), True)

            if store_history[0][0] == 'OK':
                return jsonify({'status': 'OK', 'message': 'Successfully add history'})

            elif store_history[0][0] == 'Error':
                return jsonify({'status': 'failed', 'message': 'failed to add history'})

            else:
                return jsonify({'ERROR': '404'})

        else:
            return jsonify({'status': 'failed', 'message': 'Please input required fields!'})


    def store_pulmonary(school_id, pulmonary):
        cough = pulmonary['cough']
        dyspnea = pulmonary['dyspnea']
        hemoptysis = pulmonary['hemoptysis']
        tb_exposure = pulmonary['tb_exposure']

        empty_fields = cough is '' or dyspnea is '' or hemoptysis is '' or tb_exposure is ''

        if empty_fields is False:
            store_pulmonary = spcalls.spcall('new_pulmonary',
                                             (school_id, cough, dyspnea, hemoptysis, tb_exposure), True)

            if store_pulmonary[0][0] == 'OK':
                return jsonify({'status': 'OK', 'message': 'Successfully add history'})

            elif store_pulmonary[0][0] == 'Error':
                return jsonify({'status': 'failed', 'message': 'failed to add history'})

            else:
                return jsonify({'ERROR': '404'})

        else:
            return jsonify({'status': 'failed', 'message': 'Please input required fields!'})


    def store_gut(school_id, gut):
        frequency = gut['frequency']
        flank_plan = gut['flank_plan']
        discharge = gut['discharge']
        dysuria = gut['dysuria']
        nocturia = gut['nocturia']
        dec_urine_amount = gut['dec_urine_amount']

        empty_fields = frequency is '' or flank_plan is '' or discharge is '' or dysuria is '' or nocturia is '' or dec_urine_amount is ''

        if empty_fields is False:
            store_gut = spcalls.spcall('new_gut',
                                   (school_id, frequency, flank_plan, discharge, dysuria, nocturia, dec_urine_amount),
                                   True)

            if store_gut[0][0] == 'OK':
                return jsonify({'status': 'OK', 'message': 'Successfully add gut'})

            elif store_gut[0][0] == 'Error':
                return jsonify({'status': 'failed', 'message': 'failed to add gut'})

            else:
                return jsonify({'ERROR': '404'})

        else:
            return jsonify({'status': 'failed', 'message': 'Please input required fields!'})


    def store_illness(school_id, illness):
        asthma = illness['asthma']
        ptb = illness['ptb']
        heart_problem = illness['heart_problem']
        hepa_a_b = illness['hepatitis_a_b']
        chicken_pox = illness['chicken_pox']
        mumps = illness['mumps']
        typhoid_fever = illness['typhoid_fever']

        empty_fields = asthma is '' or ptb is '' or heart_problem is '' or hepa_a_b is '' or \
                       chicken_pox is '' or mumps is '' or typhoid_fever is ''

        if empty_fields is False:
            store_illness = spcalls.spcall('new_illness',
                                           (school_id, asthma, ptb, heart_problem, hepa_a_b,
                                            chicken_pox, mumps, typhoid_fever), True)

            if store_illness[0][0] == 'OK':
                return jsonify({'status': 'OK', 'message': 'Successfully add gut'})

            elif store_illness[0][0] == 'Error':
                return jsonify({'status': 'failed', 'message': 'failed to add gut'})

            else:
                return jsonify({'ERROR': '404'})

        else:
            return jsonify({'status': 'failed', 'message': 'Please input required fields!'})


    def store_cardiac(school_id, cardiac):
        chest_pain = cardiac['chest_pain']
        palpitations = cardiac['palpitations']
        pedal_edema = cardiac['pedal_edema']
        orthopnea = cardiac['orthopnea']
        nocturnal_dyspnea = cardiac['nocturnal_dyspnea']

        empty_fields = chest_pain is '' or palpitations is '' or pedal_edema is '' or orthopnea is '' or nocturnal_dyspnea is ''

        if empty_fields is False:
            store_cardiac = spcalls.spcall('new_cardiac',
                                       (school_id, chest_pain, palpitations, pedal_edema, orthopnea, nocturnal_dyspnea),
                                       True)

            if store_cardiac[0][0] == 'OK':
                return jsonify({'status': 'OK', 'message': 'Successfully add gut'})

            elif store_cardiac[0][0] == 'Error':
                return jsonify({'status': 'failed', 'message': 'failed to add gut'})

            else:
                return jsonify({'ERROR': '404'})

        else:
            return jsonify({'status': 'failed', 'message': 'Please input required fields!'})


    def store_neurologic(school_id, neurologic):
        headache = neurologic['headache']
        seizure = neurologic['seizure']
        dizziness = neurologic['dizziness']
        loss_of_consciousness = neurologic['loss_of_consciousness']

        empty_fields = headache is '' or seizure is '' or dizziness is '' or loss_of_consciousness is ''

        if empty_fields is False:
            store_neurologic = spcalls.spcall('new_neurologic',
                                          (school_id, headache, seizure, dizziness, loss_of_consciousness), True)

            if store_neurologic[0][0] == 'OK':
                return jsonify({'status': 'OK', 'message': 'Successfully add gut'})

            elif store_neurologic[0][0] == 'Error':
                return jsonify({'status': 'failed', 'message': 'failed to add gut'})

            else:
                return jsonify({'ERROR': '404'})

        else:
            return jsonify({'status': 'failed', 'message': 'Please input required fields!'})
        