import json

from behave import *

from util import schemas_util, file_util


@given('an openapi file {filename}')
def step_impl(context, filename):
    # filename = context.vars.resolve(filename)
    filename = file_util.resolve_file_name(filename)
    schemas_util.add_openapi_schemas(filename, context)

@then('the response json matches defined schema {schema_id}')
def step_impl(context, schema_id):
    schemas_util.response_json_matches_defined_schema(context, schema_id)


@then('the response json schema matches')
def step_impl(context):
    schemas = json.loads(context.text)
    schemas_util.validate_with_schema(json.loads(context.response.text), schemas)
