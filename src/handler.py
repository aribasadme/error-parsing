import base64
import gzip
import json
import logging
import os

import boto3
from botocore.exceptions import ClientError

log = logging.getLogger()


def logpayload(event):
    log.setLevel(os.environ['LOG_LEVEL'])
    log.debug(event['awslogs']['data'])
    compressed_payload = base64.b64decode(event['awslogs']['data'])
    uncompressed_payload = gzip.decompress(compressed_payload)
    log_payload = json.loads(uncompressed_payload)
    return log_payload


def error_details(payload):
    error_msg = ""
    log_events = payload['logEvents']
    log.debug(payload)
    loggroup = payload['logGroup']
    logstream = payload['logStream']
    lambda_func_name = loggroup.split('/')
    log.info(f'LogGroup: {loggroup}')
    log.info(f'Logstream: {logstream}')
    log.info(f'Function name: {lambda_func_name[3]}')
    log.debug(log_events)
    for log_event in log_events:
        error_msg += log_event['message']
    log.info('Message: %s' % error_msg.split("\n"))
    return loggroup, logstream, error_msg, lambda_func_name


def publish_message(loggroup, logstream, error_msg, lambda_func_name):
    sns_arn = os.environ['SNS_ARN']
    snsclient = boto3.client('sns')
    try:
        message = ""
        message += "\nLambda error  summary" + "\n\n"
        message += "########################################################\n"
        message += "# LogGroup Name:- " + str(loggroup) + "\n"
        message += "# LogStream:- " + str(logstream) + "\n"
        message += "# Log Message:- " + "\n"
        message += "# \t\t" + str(error_msg.split("\n")) + "\n"
        message += "########################################################\n"

        # Sending the notification...
        snsclient.publish(
            TargetArn=sns_arn,
            Subject=f'Execution error for Lambda - {lambda_func_name[3]}',
            Message=message
        )
    except ClientError as e:
        log.error("An error occured: %s" % e)


def run(event, _):
    pload = logpayload(event)
    lgroup, lstream, errmessage, lambdaname = error_details(pload)
    publish_message(lgroup, lstream, errmessage, lambdaname)
