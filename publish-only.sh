#!/bin/bash -e

# AWS Regions
region=${AWS_REGION:?no-region}
LAYER_NAME="bash"

echo "Publishing layer to $region..."

LAYER_ARN=$(aws lambda publish-layer-version --region $region --layer-name $LAYER_NAME --description "Bash in AWS Lambda [https://github.com/gkrizek/bash-lambda-layer]" --compatible-runtimes provided --license MIT --zip-file fileb://export/layer.zip | jq -r .LayerVersionArn)

echo $LAYER_ARN
echo ""

echo "Successfully published to $region"
