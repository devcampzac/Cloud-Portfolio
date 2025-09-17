import boto3
import json
import os

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(os.environ['TABLE_NAME'])
site_domain  = os.environ.get("SITE_DOMAIN")
contact_from = os.environ["CONTACT_FROM"]
contact_to   = os.environ["CONTACT_TO"]


def lambda_handler(event, context):
    method = event["requestContext"]["http"]["method"]
    path = event["requestContext"]["http"]["path"]

    # Always add CORS headers
    cors_headers = {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "OPTIONS,GET,POST",
        "Access-Control-Allow-Headers": "Content-Type"
    }

    # Handle preflight OPTIONS request
    if method == "OPTIONS":
        return {
            "statusCode": 200,
            "headers": cors_headers
        }

    # Handle visits counter
    if path == "/visits" and method == "GET":
        response = table.update_item(
            Key={"site": os.environ.get("SITE_DOMAIN")},
            UpdateExpression="ADD visits :inc",
            ExpressionAttributeValues={":inc": 1},
            ReturnValues="UPDATED_NEW"
        )

        return {
            "statusCode": 200,
            "headers": cors_headers,
            "body": json.dumps({"visits": int(response["Attributes"]["visits"])})
        }

    # Handle contact form
    if path == "/contact" and method == "POST":
        body = json.loads(event.get("body", "{}"))
        name = body.get("name", "")
        email = body.get("email", "")
        message = body.get("message", "")

        # 🚨 Example: send via SES (or just log for now)
        ses = boto3.client("ses")
        ses.send_email(
            Source=os.environ["CONTACT_FROM"],
            Destination={"ToAddresses": [os.environ["CONTACT_TO"]]},
            Message={
                "Subject": {"Data": f"Portfolio Contact from {name}"},
                "Body": {"Text": {"Data": f"From: {name} <{email}>\n\n{message}"}}
            }
        )

        return {
            "statusCode": 200,
            "headers": cors_headers,
            "body": json.dumps({"message": "Message sent successfully!"})
        }

    # Default fallback
    return {
        "statusCode": 404,
        "headers": cors_headers,
        "body": json.dumps({"error": "Not Found"})
    }
