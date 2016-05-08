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


def store_assessment(data):
    school_id = data['school_id']
    age = data['age']
    temperature = data['temperature']
    pulse_rate = data['pulse_rate']
    respiration_rate = data['respiration_rate']
    blood_pressure = data['blood_pressure']
    weight = data['weight']
    chief_complaint = data['chief_complaint']
    history_of_present_illness = data['history_of_present_illness']
    medications_taken = data['medications_taken']
    diagnosis = data['diagnosis']
    recommendation = data['recommendation']
    attending_physician = data['attending_physician']


    check_schoolID = spcalls.spcall('check_schoolID',(school_id,))


    if check_schoolID[0][0] == 'OK' :
        return jsonify({"status": "FAILED", "message": "School ID does not exist."})

    elif (school_id is None or
        age is None or
        temperature is None or
        pulse_rate is None or
        pulse_rate is None or
        blood_pressure is None or
        weight is None or
        attending_physician is None or
        chief_complaint == '' or
        history_of_present_illness == '' or
        medications_taken == '' or
        diagnosis == '' or
        recommendation == ''):

        return jsonify({"status":"FAILED" , "message":"Please fill the required fields"})

    else:
        assessment = spcalls.spcall('store_assessment', (school_id,
                                                         age,
                                                         chief_complaint,
                                                         history_of_present_illness,
                                                         medications_taken,
                                                         diagnosis,
                                                         recommendation,
                                                         attending_physician), True)

        vital_signs_id = int(assessment[0][0])

        if 'Error' in str(assessment[0][0]):
            return jsonify({"status": "FAILED"})

        else:

            vital_signs = spcalls.spcall('update_vitalSigns', (vital_signs_id,
                                                               temperature,
                                                               pulse_rate,
                                                               respiration_rate,
                                                               blood_pressure,
                                                               weight), True)
            if 'Error' in str(vital_signs[0][0]):
                return jsonify({"status":"FAILED", "message":vital_signs[0][0]})

            else:
                return jsonify({"status": "OK", "message":vital_signs[0][0]})

