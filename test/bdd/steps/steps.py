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


""" Feature : Assessment """

""" Scenario: Create assessment successfully """


@step(u'Given the nurse have the following assessment details:')
def given_the_nurse_have_the_following_assessment_details(step):
    world.assessment = step.hashes[0]


@step(u'When  the nurse clicks the add button')
def when_the_nurse_clicks_the_add_button(step):
    world.browser = TestApp(app)
    world.response = world.app.post('/api/anoncare/assessment', data=json.dumps(world.assessment))