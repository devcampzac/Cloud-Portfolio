import os
import boto3
import json

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(os.environ['TABLE_NAME'])
site_key = os.environ['SITE_KEY']

def lambda_handler(event, context):
    response = table.update_item(
        Key={'site': site_key},
        UpdateExpression="ADD visits :inc",
        ExpressionAttributeValues={':inc': 1},
        ReturnValues="UPDATED_NEW"
    )

    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Methods": "GET"
        },
        "body": json.dumps({"visits": int(response['Attributes']['visits'])})
    }
