import json
from app import *
from models import DBconn
from flask.ext.httpauth import HTTPBasicAuth
from flask import request
import re
import hashlib
from flask import jsonify
from spcalls import SPcalls


def get_school_id():
    data = json.loads(request.data)
    school_id = data['school_id']

    return school_id


def store_patient_info(data):
    school_id = get_school_id()