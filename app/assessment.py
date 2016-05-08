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

def show_assessment(school_id, assesment_id):
    spcalls = SPcalls()
    print "spcall", spcalls
    #when you have only one parameter you need to user "," comma.
    #example: spcals('show_user_id', (id,) )
    assess = spcalls.spcall('show_assessment_id', (id,))
    data = [] 

    if len(assess) == 0: 
        return jsonify({"status": "FAILED", "message": "No User Found", "entries": []})

    else:
        r = assess[0]
        data.append({"assesment_id": r[0],
                     "school_id":r[2],
                     "assessment_date":r[1],
                     "age":r[3],
                     "temperature":r[11],
                     "pulse_rate":r[12],
                     "respiration_rate":r[13],
                     "blood_pressure": r[14],
                     "weight": r[15],
                     "chief_complaint": r[5],
                     "history_of_present_illness": r[6],
                     "medications_taken": r[7],
                     "diagnosis": r[8],
                     "recommendation": r[9],
                     "attending_physician": r[16] + ' ' + r[17]})
        return jsonify({"status": "OK", "message": "OK", "entries": data})