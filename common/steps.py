from __future__ import unicode_literals

from behave import *
import nose
import requests
from nose.tools import assert_equal
import jpath
import json

use_step_matcher("parse")


@step('I set base URL to "{base_url}"')
def set_base_url(context, base_url):
    if base_url.startswith("context"):
        context.base_url = getattr(context, base_url[8:])
    else:
        context.base_url = base_url.encode('ascii')


@step('I add path "{path}" to base URL')
def add_path_to_url(context, path):
    context.base_url += "/" + path


@step('I make a {request_verb} request to "{url_path_segment}"')
def get_request(context, request_verb, url_path_segment):
    if not hasattr(context, 'verify_ssl'):
        context.verify_ssl = True

    url = context.base_url + '/' + url_path_segment

    context.response = getattr(requests, request_verb.lower())(url, headers=context.headers, verify=context.verify_ssl)

    log_full(context.response)

    return context.response


@step('I make a {request_verb} request to "{url_path_segment}" with parameters')
def request_with_parameters(context, request_verb, url_path_segment):
    if not hasattr(context, 'verify_ssl'):
        context.verify_ssl = True

    url = context.base_url + '/' + url_path_segment

    params = {}

    for row in context.table:
        for x in context.table.headings:
            params[x] = row[x]
            if row[x].startswith("context"):
                params[x] = eval(row[x])

    context.response = getattr(requests, request_verb.lower())(url, params, headers=context.headers,
                                                               verify=context.verify_ssl)

    log_full(context.response)

    return context.response


@step('the response status code should equal {expected_http_status_code}')
def status_code_validation(context, expected_http_status_code):
    nose.tools.assert_equal(context.response.status_code, int(expected_http_status_code))

@step('the response status message should equal "{expected_http_status_message}"')
def status_message_validation(context, expected_http_status_message):
    nose.tools.assert_equal(context.response.reason, str(expected_http_status_message))

@then('the response contains a json body like')
def step_impl(context):
    expected_json_body = json.loads(context.text)
    nose.tools.assert_equal(json.loads(context.response.text), expected_json_body)


@then('the response contains text')
def step_impl(context):
    nose.tools.assert_equal(context.response.text, context.text)


def log_full(r):
    req = r.request
    """
    At this point it is completely built and ready
    to be fired; it is "prepared".

    However pay attention at the formatting used in
    this function because it is programmed to be pretty
    printed and may differ from the actual request.
    """

    print("")
    print("")

    print('{}\n{}\n{}\n\n{}'.format(
        '-----------REQUEST-----------',
        req.method + ' ' + req.url,
        '\n'.join('{}: {}'.format(k, v) for k, v in req.headers.items()),
        req.body,
    ))

    print("")

    print('{}\n{}\n{}\n\n{}'.format(
        '-----------RESPONSE-----------',
        str(r.status_code) + ' ' + r.reason,
        '\n'.join('{}: {}'.format(k, v) for k, v in r.headers.items()),
        r.text,
    ))
    print("")

    print('Operation took ' + str(round(r.elapsed.total_seconds(), 3)) + 's')

    print("")
    print("")
    print("")
    print("")
