#!/bin/bash

PAYLOAD="{\"email_address\": \"$3\"}"

# Invoke Lambda function
aws lambda invoke \
  --profile "$1" \
  --region "$2" \
  --function-name "versent-create-new-snowflake-user" out \
  --cli-binary-format raw-in-base64-out \
  --payload "$PAYLOAD" \
  --log-type Tail \
  --query "LogResult" \
  --output text \
  --cli-binary-format raw-in-base64-out | base64 --decode


