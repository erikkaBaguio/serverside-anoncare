from lettuce import step, world, before
from nose.tools import assert_equals
from webtest import *
from app import app
import json


@before.all
def before_all():
    world.app = app.test_client()


""" Common steps for jsonify response """


@step(u'Then  it should have a \'([^\']*)\' response')
def then_it_should_get_a_group1_response(step, expected_status_code):
    assert_equals(world.response.status_code, int(expected_status_code))


@step(u'And   it should have a field \'([^\']*)\' containing \'([^\']*)\'')
def and_it_should_get_a_field_group1_containing_group2(step, field, expected_value):
    world.response_json = json.loads(world.response.data)
    assert_equals(str(world.response_json[field]), expected_value)


@step(u'And   school id \'([^\']*)\' exists')
def and_school_id_group1_exists(step, school_id):
    world.check_schoolID = world.app.get('/app/anoncare/school_id_exists/{}/'.format(school_id))
    assert_equals(world.check_schoolID['status'], 'OK')


""" Feature : Assessment """
""" Scenario: Create assessment successfully """


@step(u'Given the nurse have the following assessment details:')
def given_the_nurse_have_the_following_assessment_details(step):
    world.assessment = step.hashes[0]


@step(u'When  the nurse clicks the send button')
def when_the_nurse_clicks_the_send_button(step):
    world.browser = TestApp(app)
    world.response = world.app.post('/api/anoncare/assessment', data=json.dumps(world.assessment))


""" Feature : View Assessment """
""" Scenario: View all assessment of a patient """


@step(u'Given the assessment of patient with school id \'([^\']*)\'')
def given_the_assessment_of_patient_with_school_id_group1(step, school_id):
    world.school_id = school_id
    world.assessment = world.app.get('/api/anoncare/assessment/{}/'.format(school_id))
    world.response_json = json.loads(world.assessment.data)
    assert_equals(world.response_json['status'], 'OK')


@step(u'When  the doctor click search button')
def when_the_doctor_click_search_button(step):
    world.browser = TestApp(app)
    world.response = world.app.get('/api/anoncare/assessment/{}/'.format(world.school_id))


@step("the following details will be returned")
def step_impl(step):
    response_json = json.loads(world.response.data)
    assert_equals(world.response_json['entries'], response_json['entries'])


""" Feature : View Assessment """
""" Scenario: View an assessment of a patient """


@step(u'Given the patient assessment with an assessment id \'([^\']*)\'')
def given_the_patient_assessment_with_an_assessment_id_group1(step, assessment_id):
    world.assessment_id = assessment_id
    world.assessment = world.app.get('/api/anoncare/assessment/by/{}'.format(assessment_id))
    world.response_json = json.loads(world.assessment.data)
    assert_equals(world.response_json['status'], 'OK')


@step(u'When  the doctor click view button')
def when_the_doctor_click_view_button(step):
    world.browser = TestApp(app)
    world.response = world.app.get('/api/anoncare/assessment/by/{}'.format(world.assessment_id))