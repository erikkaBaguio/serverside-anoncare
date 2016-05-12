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


def check_schoolID(school_id):
    """Returns t response if school id exists, otherwise f"""
    schoolID_response = spcalls.spcall('school_id_exists', (school_id,))

    return schoolID_response[0][0]


def school_id_checker(school_id):
    response = check_schoolID(school_id)

    if response == 'f':
        return jsonify({"status": "FAILED", "message": "School ID does not exists"})

    else:
        return jsonify({"status": "OK", "message": "School ID exists"})


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

    #school_id must be cast to integer.
    print school_id
    check_schoolID_exists = check_schoolID( int(school_id))

    if not school_id:
        return jsonify({"status": "FAILED", "message": "Please input school ID."})

    elif check_schoolID_exists == 'f':
        return jsonify({"status": "FAILED", "message": "School ID does not exist."})

    # elif type(school_id) != int:
    #     return jsonify({"status": "FAILED", "message": "Invalid school ID."})
    #
    # elif (type(age) != int or
    #       type(temperature) != float or
    #       type(pulse_rate) != int or
    #       type(respiration_rate) != int or
    #       type(weight) != float or
    #       type(attending_physician) != int
    #       ):
    #
    #     return jsonify({"status": "FAILED", "message": "Invalid input."})

        """
            Checks if json data is null
        """
    elif (not age or
              not attending_physician or
              not temperature or
              not respiration_rate or
              not pulse_rate or
              not weight or
                  blood_pressure == '' or
                  attending_physician is None or
                  chief_complaint == '' or
                  history_of_present_illness == '' or
                  medications_taken == '' or
                  diagnosis == '' or
                  recommendation == ''):

        return jsonify({"status": "FAILED", "message": "Please fill the required fields"})

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

        print 'vsId', vital_signs_id

        if 'Error' in str(assessment[0][0]):
            return jsonify({"status": "FAILED", "message":assessment[0][0]})

        else:

            vital_signs = spcalls.spcall('update_vitalSigns', (vital_signs_id,
                                                               temperature,
                                                               pulse_rate,
                                                               respiration_rate,
                                                               blood_pressure,
                                                               weight), True)
            if 'Error' in str(vital_signs[0][0]):
                return jsonify({"status": "FAILED", "message": vital_signs[0][0]})

            else:
                return jsonify({"status": "OK", "message": vital_signs[0][0]})


def show_assessment_id(school_id, assessment_id):

    assess = spcalls.spcall('show_assessment_id', (school_id, assessment_id,))
    data = []

    if len(assess) == 0:
        return jsonify({"status": "FAILED", "message": "No User Found", "entries": []})

    elif 'Error' in str(assess[0][0]):
        return jsonify({"status": "FAILED", "message": assess[0][0]})

    else:
        r = assess[0]
        data.append({"assessment_id": r[0],
                     "assessment_date": r[1],
                     "school_id": r[2],
                     "age": r[3],
                     "vital_signid": r[4],
                     "temperature": r[11],
                     "pulse_rate": r[12],
                     "respiration_rate": r[13],
                     "blood_pressure": r[14],
                     "weight": r[15],
                     "chief_complaint": r[16],
                     "history_of_present_illness": r[6],
                     "medications_taken": r[7],
                     "diagnosis": r[8],
                     "recommendation": r[9],
                     "attending_physician": r[17] + ' ' + r[18]})
        return jsonify({"status": "OK", "message": "OK", "entries": data})


def show_assessment(school_id):

    assessments = spcalls.spcall('show_assessment', (school_id,))
    entries = []

    check_schoolID_exists = check_schoolID(school_id)

    if not school_id:
        return jsonify({"status": "FAILED", "message": "Please input school ID."})

    elif check_schoolID_exists == 'f':
        return jsonify({"status": "FAILED", "message": "School ID does not exist."})

    elif 'Error' in str(assessments[0][0]):
        return jsonify({"status": "FAILED", "message": assessments[0][0]})

    elif len(assessments) != 0:
        for r in assessments:
            entries.append({"assessment_id": r[0],
                     "assessment_date": r[1],
                     "school_id": r[2],
                     "age": r[3],
                     "vital_signid": r[4],
                     "temperature": r[11],
                     "pulse_rate": r[12],
                     "respiration_rate": r[13],
                     "blood_pressure": r[14],
                     "weight": r[15],
                     "chief_complaint": r[16],
                     "history_of_present_illness": r[6],
                     "medications_taken": r[7],
                     "diagnosis": r[8],
                     "recommendation": r[9],
                     "attending_physician": r[17] + ' ' + r[18]})

        return jsonify({"status": "OK", "message": "OK", "entries": entries, "count":len(entries)})

    else:
        return jsonify({"status": "FAILED", "message": "No Assessment Found", "entries": []})


def show_all_doctors():
    doctors = spcalls.spcall('show_all_doctors',())
    entries = []

    if 'Error' in str(doctors[0][0]):
        return jsonify({"status": "FAILED", "message": doctors[0][0]})

    elif len(doctors) != 0:
        for doctor in doctors:
            entries.append({ "id" : doctor[0],
                             "fname": doctor[1],
                             "mname": doctor[2],
                             "lname": doctor[3],
            })

        return jsonify({"status":"OK", "message":"OK", "entries":entries, "count":len(entries)})

    else:
        return jsonify({"status": "FAILED", "message": "No Doctor Found", "entries": []})
