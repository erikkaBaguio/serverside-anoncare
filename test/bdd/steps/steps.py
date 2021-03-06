from lettuce import step, world, before
from nose.tools import assert_equals
from webtest import *
from app import app
import base64
import json


@before.all
def before_all():
    world.app = app.test_client()
    world.headers = {'Authorization': 'Basic %s' % base64.b64encode("name:pass")}

""" Common steps for jsonify response """


@step(u'Then  it should have a \'([^\']*)\' response')
def then_it_should_get_a_group1_response(step, expected_status_code):
    assert_equals(world.response.status_code, int(expected_status_code))


@step(u'And   it should have a field \'([^\']*)\' containing \'([^\']*)\'')
def and_it_should_get_a_field_group1_containing_group2(step, field, expected_value):
    world.response_json = json.loads(world.response.data)
    assert_equals(str(world.response_json[field]), expected_value)

""" Feature: User Accounts """

""" Scenario: Retrieve a user's details """

@step(u'Given user with id \'([^\']*)\'')
def given_user_with_id_group1(step, id):
    world.user = world.app.get('/api/anoncare/user/{}/'.format(id), headers = world.headers)
    world.response_json = json.loads(world.user.data)

@step(u'When the admin enter with an id \'([^\']*)\'')
def when_the_admin_enter_with_an_id_group1(step, id):
    world.response = world.app.get('/api/anoncare/user/{}/'.format(id), headers = world.headers)

@step(u'And the following details will be returned')
def and_the_following_user_details_will_be_returned(step):
    resp = json.loads(world.response.data)
    assert_equals(world.response_json['entries'], resp['entries'])


@step(u'And   school id \'([^\']*)\' exists')
def and_school_id_group1_exists(step, school_id):
    world.check_schoolID = world.app.get('/app/anoncare/school_id_exists/{}/'.format(school_id), headers = world.headers)
    assert_equals(world.check_schoolID['status'], 'FAILED')


""" Feature : Assessment """
""" Scenario: Create assessment successfully """


@step(u'Given the nurse have the following assessment details:')
def given_the_nurse_have_the_following_assessment_details(step):
    world.assessment = step.hashes[0]


@step(u'And school id \'([^\']*)\' exists')
def and_school_id_group1_exists(step, school_id):
    world.check_schoolID  = world.app.get('/app/anoncare/school_id_exists/{}/'.format(school_id), headers = world.headers)



@step(u'When  the nurse clicks the send button')
def when_the_nurse_clicks_the_send_button(step):
    world.browser = TestApp(app)
    world.response = world.app.post('/api/anoncare/assessment', headers = world.headers, data=json.dumps(world.assessment))

""" Feature : View Assessment """
""" Scenario: View all assessment of a patient """


@step(u'Given the assessment of patient with school id \'([^\']*)\'')
def given_the_assessment_of_patient_with_school_id_group1(step, school_id):
    world.school_id = school_id
    world.assessment = world.app.get('/api/anoncare/assessment/{}/'.format(school_id), headers = world.headers)


@step(u'When  the doctor click search button')
def when_the_doctor_click_search_button(step):
    world.browser = TestApp(app)
    world.response = world.app.get('/api/anoncare/assessment/{}/'.format(world.school_id), headers = world.headers)


@step("the following details will be returned")
def step_impl(step):
    response_json = json.loads(world.response.data)
    assert_equals(world.response_json['entries'], response_json['entries'])


""" Feature : View Assessment """
""" Scenario: View an assessment of a patient """


@step(u'Given the patient assessment with an assessment id \'([^\']*)\'')
def given_the_patient_assessment_with_an_assessment_id_group1(step, assessment_id):
    world.assessment_id = assessment_id
    world.assessment = world.app.get('/api/anoncare/assessment/by/{}'.format(assessment_id), headers = world.headers)
    world.response_json = json.loads(world.assessment.data)
    assert_equals(world.response_json['status'], 'OK')


@step(u'When  the doctor click view button')
def when_the_doctor_click_view_button(step):
    world.browser = TestApp(app)
    world.response = world.app.get('/api/anoncare/assessment/by/{}'.format(world.assessment_id), headers = world.headers)


""" Scenario: Update assessment """
@step(u'Given the details of the patient assessment')
def given_the_details_of_the_patient_assessment(step):
    world.assessment_oldInfo = step.hashes[0]


@step(u'And   the new details for the patient assessment')
def and_the_new_details_for_the_patient_assessment(step):
    world.assessment_updatedInfo = step.hashes[0]


@step(u'When  the doctor clicks the update button')
def when_the_doctor_clicks_the_update_button(step):
    world.browser = TestApp(app)
    world.response = world.app.put('/api/anoncare/assessment', headers = world.headers, data=json.dumps(world.assessment_updatedInfo))


""" Feature : Search User """
""" Scenario: Search user successfully  """


@step(u'Given the entered keyword')
def given_the_entered_keyword(step):
    world.user_keyword = step.hashes[0]


@step(u'When  the admin click search button')
def when_the_admin_click_search_button(step):
    world.browser = TestApp(app)
    world.response = world.app.post('/api/anoncare/user/search', headers = world.headers, data=json.dumps(world.user_keyword))


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
    world.check_username = world.app.get('/api/anoncare/username/{}'.format(id), headers = world.headers)


@step(u'And   the username \'([^\']*)\' does not yet exist')
def and_the_username_group1_does_not_yet_exist(step, username):
    world.check_username = world.app.get('/api/anoncare/username/{}'.format(username), headers = world.headers)


@step(u'When  admin clicks the register button')
def when_admin_clicks_the_register_button(step):
    world.browser = TestApp(app)
    world.response = world.app.post('/api/anoncare/user', headers = world.headers, data=json.dumps(world.new_user))


@step(u'And   the email \'([^\']*)\' exists')
def and_the_email_group1_exists(step, email):
    world.check_email = world.app.get('/api/anoncare/email/{}'.format(email), headers = world.headers)


@step(u'Given user with id \'([^\']*)\'')
def given_user_with_id_group1(step, user_id):
    world.user_id = user_id
    world.user = world.app.get('/api/anoncare/user/{}/'.format(user_id), headers = world.headers)
    world.response_json = json.loads(world.user.data)


@step(u'When  the admin click view user')
def when_the_admin_click_view_user(step):
    world.browser = TestApp(app)
    world.response = world.app.get('/api/anoncare/user/{}/'.format(world.user_id), headers = world.headers)


@step(u'Given user with email:')
def given_user_with_email(step):
    world.new_password = step.hashes[0]


@step(u'When  the user submits the form')
def when_the_user_submits_the_form(step):
    world.response = world.app.put('/api/anoncare/forgot_password', headers = world.headers, data=json.dumps(world.new_password))

""" Feature : Patient Files """
""" Scenario: Create patient file successfully """
@step(u'Given the following details of patient')
def given_the_following_details_of_patient(step):
    world.patient = step.hashes[0]


@step(u'When  I click the add button')
def when_i_click_the_add_button(step):
    world.browser = TestApp(app)
    world.response = world.app.post('/api/anoncare/patient', headers= world.headers, data=json.dumps(world.patient))


@step(u'Given the patient file with school id \'([^\']*)\'')
def given_the_patient_file_with_school_id_group1(step, school_id):
    world.browser = TestApp(app)
    world.school_id = school_id
    world.response = world.app.get('/api/anoncare/patient/{}/'.format(school_id), headers = world.headers)
    world.response_json = json.loads(world.response.data)


@step(u'When  the doctor click view patient file')
def when_the_doctor_click_view_patient_file(step):
    world.browser = TestApp(app)
    world.response = world.app.get('/api/anoncare/patient/{}/'.format(world.school_id), headers = world.headers)


""" Feature : Login """
""" Scenario: Logged in successfully """


@step(u'Given the following credentials')
def given_the_following_credentials(step):
    world.credentials = step.hashes[0]


@step(u'When  the login button is clicked')
def when_the_login_button_is_clicked(step):
    world.browser = TestApp(app)
    world.response = world.app.post('/auth', data=json.dumps(world.credentials))


###
@step(u'Given the nurse already assess the patient with assessment id 6')
def already_assess(step):
    """
    :type step: lettuce.core.Step
    """
    world.browser = TestApp(app)
    world.assessments = world.browser.get('/api/anoncare/assessment/by/6', headers = world.headers)
    world.assessments.charset = 'utf8'
    assert_equals(json.loads(world.assessments.text)[u'status'], "OK")

@step(u'When the nurse request an appointment to the doctor with id 3')
def request_appointment(step):
    world.response = world.browser.get('/api/anoncare/notification/61', headers = world.headers)
    world.response.charset = 'utf8'
    assert_equals(json.loads(world.response.text)[u'status'], "OK")

@step(u'Then I should get \'([^\']*)\' response')
def then_i_should_get_a_group2_response(step, expected_status_code):
    assert_equals(world.response.status_code, int(expected_status_code))

@step(u'And the following details are returned:')
def notification_details(step):
    world.notification = world.app.get('/api/anoncare/notification/61', headers = world.headers)
    world.resp = json.loads(world.notification.data)[u'entries']
    world.notification_returned = step.hashes[0]
    assert_equals(world.notification_returned, world.resp[0])

@step(u'Given the doctor with id 3 click the notification button')
def doctor_notification(step):
    world.notification = world.app.get('/api/anoncare/notification/62', headers = world.headers)
    world.notification.charset = 'utf8'

@step(u'When there is no available notification for doctor with id 3')
def no_available_notification(step):
    # assert_equals(json.loads(world.notification.data)[u'status'], "OK")
    world.notification = world.app.get('/api/anoncare/notification/62', headers = world.headers)


@step(u'Then return a \'([^\']*)\' response')
def then_return_a(step, expected_status_code):
    assert_equals(world.response.status_code, int(expected_status_code))

@step(u'And the following message will pop out No available notifications')
def notification_message(step):
    world.notification = world.app.get('/api/anoncare/notification/62', headers = world.headers)


    #assert_equals(json.loads(world.notification.data)[u'message'], "Error reading notification")


