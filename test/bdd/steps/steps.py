from lettuce import step, world, before
from nose.tools import assert_equals
from webtest import *
from app import app
import json

@before.all
def before_all():
    world.app = app.test_client()

""" Common steps for jsonify response """

@step(u'Given user with id \'([^\']*)\'')
def given_user_with_id_group1(step, id):
	world.user = world.app.get('/api/anoncare/user/{}/'.format(id))
	world.response_json = json.loads(world.user.data)
	assert_equals(world.response_json['status'], 'OK')

@step(u'When the admin enter with an id \'([^\']*)\'')
def when_the_admin_enter_with_an_id_group1(step, id):
    world.response = world.app.get('/api/anoncare/user/{}/'.format(id))

@step(u'Then it should have a \'([^\']*)\' response')
def then_it_should_have_a_group1_response(step, expected_status_code):
    assert_equals(world.response.status_code, int(expected_status_code))

@step(u'And it should have a field \'([^\']*)\' containing \'([^\']*)\'')
def and_it_should_have_a_field_group1_containing_group2(step, field, expected_status_code):
	world.resp = json.loads(world.response.data)
	assert_equals(world.resp[field], expected_status_code)

@step(u'And the following user details will be returned:')
def and_the_following_user_details_will_be_returned(step):
	resp = json.loads(world.response.data)
	assert_equals(world.resp['entries'], resp['entries'])