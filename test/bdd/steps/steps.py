from lettuce import step, world, before
from nose.tools import assert_equals
from webtest import *
from app import app
import json

@before.all
def before_all():
    world.app = app.test_client()

""" Common steps for jsonify response """


@step(u'Then it should have a \'([^\']*)\' response')
def then_it_should_get_a_group1_response(step, expected_status_code):
    assert_equals(world.response.status_code, int(expected_status_code))


@step(u'And it should have a field \'([^\']*)\' containing \'([^\']*)\'')
def and_it_should_get_a_field_group1_containing_group2(step, field, expected_value):
    world.response_json = json.loads(world.response.data)
    assert_equals(world.response_json[field], expected_value)

""" Feature: User Accounts """

""" Scenario: Retrieve a user's details """

@step(u'Given user with id \'([^\']*)\'')
def given_user_with_id_group1(step, id):
	world.user = world.app.get('/api/anoncare/user/{}/'.format(id))
	world.response_json = json.loads(world.user.data)

@step(u'When the admin enter with an id \'([^\']*)\'')
def when_the_admin_enter_with_an_id_group1(step, id):
    world.response = world.app.get('/api/anoncare/user/{}/'.format(id))

@step(u'And the following details will be returned')
def and_the_following_user_details_will_be_returned(step):
	resp = json.loads(world.response.data)
	assert_equals(world.response_json['entries'], resp['entries'])


@step(u'And   school id \'([^\']*)\' exists')
def and_school_id_group1_exists(step, school_id):
    world.check_schoolID = world.app.get('/app/anoncare/school_id_exists/{}/'.format(school_id))


""" Feature : Assessment """
""" Scenario: Create assessment successfully """


@step(u'Given the nurse have the following assessment details:')
def given_the_nurse_have_the_following_assessment_details(step):
    world.assessment = step.hashes[0]


@step(u'And school id \'([^\']*)\' exists')
def and_school_id_group1_exists(step, school_id):
    world.check_schoolID  = world.app.get('/app/anoncare/school_id_exists/{}/'.format(school_id))


@step(u'When  the nurse clicks the send button')
def when_the_nurse_clicks_the_send_button(step):
    world.browser = TestApp(app)
    world.response = world.app.post('/api/anoncare/assessment', data=json.dumps(world.assessment))


""" Feature : View Assessment """
""" Scenario : View Assessment of a Patient """

# @step(u'Given the patient assessment with school id \'([^\']*)\'')
# def given_the_patient_assessment_with_school_id_group1(step, school_id):

""" Feature : View Assessment """
""" Scenario: View all assessment of a patient """


@step(u'Given the assessment of patient with school id \'([^\']*)\'')
def given_the_assessment_of_patient_with_school_id_group1(step, school_id):
    world.assessment = world.app.get('/api/anoncare/assessment/{}/'.format(school_id))
    world.response_json = json.loads(world.assessment.data)
    assert_equals(world.response_json['status'], 'OK')


@step(u'And the patient assessment with an assessment id \'([^\']*)\'')
def and_the_patient_assessment_with_an_assessment_id_group1(step, assessment_id):
    world.assessment = world.app.get('/api/anoncare/assessment/20131288/{}/'.format(assessment_id))
    world.response_json = json.loads(world.assessment.data)
    assert_equals(world.response_json['status'], 'OK')

# @step(u'When the doctor click view assessment with an id \'([^\']*)\'')
# def when_the_doctor_click_view_assessment_with_an_id_group1(step, school_id):
#     world.response = world.app.get('/api/anoncare/assessment/{}/'.format(school_id))

# # # @step(u'And the following details will be returned')
# # # def and_the_following_details_will_be_returned(step):
# # #     resp= json.loads(world.assessment.data)
# # #     assert_equals(world.resp['entries'], resp['entries'])



# @step(u'And   school id \'([^\']*)\' does not exists')
# def and_school_id_group1_does_not_exists(step, school_id):
#     world.check_schoolID = world.app.get('/app/anoncare/school_id_exists/{}/'.format(school_id))

@step(u'When  the doctor click search button')
def when_the_doctor_click_search_button(step):
    world.browser = TestApp(app)
    world.response = world.app.get('/api/anoncare/assessment/20130000/')


@step(u'And   the following details will be returned')
def and_the_following_details_will_be_returned(step):
    response_json = json.loads(world.assessment.data)
    assert_equals(world.response_json['entries'], response_json['entries'])


@step(u'And   school id \'([^\']*)\' does not exists')
def and_school_id_group1_does_not_exists(step, school_id):
    world.check_schoolID = world.app.get('/app/anoncare/school_id_exists/{}/'.format(school_id))


""" Feature : Patient Files """
""" Scenario: Create patient successfully """


@step(u'Given the following details of patient')
def given_the_following_details_of_patient(step):
    world.patient = step.hashes[0]


@step(u'When I click the add button')
def when_i_click_the_add_button(step):
    world.browser = TestApp(app)
    world.patient_response = world.app.post('/api/anoncare/patient', data=json.dumps(world.patient))


""" Feature : Search User """
""" Scenario: Search user successfully  """


@step(u'Given the entered keyword')
def given_the_entered_keyword(step):
    world.user_keyword = step.hashes[0]


@step(u'When  the admin click search button')
def when_the_admin_click_search_button(step):
    world.browser = TestApp(app)
    world.response = world.app.post('/api/anoncare/user/search', data=json.dumps(world.user_keyword))


@step(u'And   the following details will be returned')
def and_the_following_details_will_be_returned(step):
    response_json = json.loads(world.response.data)
    assert_equals(world.response_json['data'], response_json['data'])
