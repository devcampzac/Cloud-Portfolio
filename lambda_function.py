import os
import json
import boto3

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(os.environ['TABLE_NAME'])
site_key = os.environ['SITE_KEY']
ses = boto3.client("ses")

DEST_EMAIL = os.environ["DEST_EMAIL"]

def lambda_handler(event, context):
    path = event.get("rawPath", "")

    if path == "/visits":
        return handle_visits()
    elif path == "/contact":
        return handle_contact(event)
    else:
        return {
            "statusCode": 404,
            "headers": {"Access-Control-Allow-Origin": "*"},
            "body": json.dumps({"error": "Not found"})
        }

def handle_visits():
    response = table.update_item(
        Key={"site": site_key},
        UpdateExpression="ADD visits :inc",
        ExpressionAttributeValues={":inc": 1},
        ReturnValues="UPDATED_NEW"
    )

    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Methods": "GET"
        },
        "body": json.dumps({"visits": int(response["Attributes"]["visits"])})
    }

def handle_contact(event):
    body = json.loads(event.get("body", "{}"))

    name = body.get("name", "Unknown")
    email = body.get("email", "No email provided")
    message = body.get("message", "")

    ses.send_email(
        Source=DEST_EMAIL,
        Destination={"ToAddresses": [DEST_EMAIL]},
        Message={
            "Subject": {"Data": f"Contact Form: {name}"},
            "Body": {"Text": {"Data": f"From: {name}\nEmail: {email}\n\nMessage:\n{message}"}}
        }
    )

    return {
        "statusCode": 200,
        "headers": {"Access-Control-Allow-Origin": "*"},
        "body": json.dumps({"status": "Message sent"})
    }
