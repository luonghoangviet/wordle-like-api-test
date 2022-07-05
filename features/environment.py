import config
def before_all(context):
    context.base_url = config.BASE_URL
    context.headers = {}
