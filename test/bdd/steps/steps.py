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


@step(u'And   the patient assessment with an assessment id \'([^\']*)\'')
def and_the_patient_assessment_with_an_assessment_id_group1(step, assessment_id):
    world.assessment_id = assessment_id
    world.assessment = world.app.get('/api/anoncare/assessment/{}/{}/'.format(world.school_id, assessment_id))
    world.response_json = json.loads(world.assessment.data)
    assert_equals(world.response_json['status'], 'OK')


@step(u'When  the doctor click view assessment')
def when_the_doctor_click_view_assessment(step):
    world.browser = TestApp(app)
    world.response = world.app.get('/api/anoncare/assessment/{}/{}/'.format(world.school_id, world.assessment_id))


@step(u'When  the doctor click search button')
def when_the_doctor_click_search_button(step):
    world.browser = TestApp(app)
    world.response = world.app.get('/api/anoncare/assessment/{}/'.format(world.school_id))


@step("the following assessment details will be returned")
def step_impl(step):
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


@step(u'When  I click the add button')
def when_i_click_the_add_button(step):
    world.browser = TestApp(app)
    world.response = world.app.post('/api/anoncare/patient', data=json.dumps(world.patient))


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
    assert_equals(world.response_json['entries'], response_json['entries'])


""" Feature : User Accounts """
""" Scenario: Create patient successfully """


@step(u'Given the following details of a user:')
def given_the_following_details_of_a_user(step):
    world.new_user = step.hashes[0]


@step(u'And   the username \'([^\']*)\' exists')
def and_the_username_group1_exists(step, group1):
    world.check_username = world.app.get('/api/anoncare/username/{}'.format(id))


@step(u'And   the username \'([^\']*)\' does not yet exist')
def and_the_username_group1_does_not_yet_exist(step, username):
    world.check_username = world.app.get('/api/anoncare/username/{}'.format(username))


@step(u'When  admin clicks the register button')
def when_admin_clicks_the_register_button(step):
    world.browser = TestApp(app)
    world.response = world.app.post('/api/anoncare/user', data=json.dumps(world.new_user))


@step(u'And   the email \'([^\']*)\' exists')
def and_the_email_group1_exists(step, email):
    world.check_email = world.app.get('/api/anoncare/email/{}'.format(email))


@step(u'Given user with id \'([^\']*)\'')
def given_user_with_id_group1(step, user_id):
    world.user_id = user_id
    world.user = world.app.get('/api/anoncare/user/{}/'.format(user_id))
    world.response_json = json.loads(world.user.data)


@step(u'When  the admin click view user')
def when_the_admin_click_view_user(step):
    world.browser = TestApp(app)
    world.response = world.app.get('/api/anoncare/user/{}/'.format(world.user_id))