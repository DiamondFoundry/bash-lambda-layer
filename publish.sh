#!/bin/bash -e
GIT_VER=$(git describe --tags)
DATE=$(date +%Y-%m-%dT%H:%M:%S%z)
DESCRIPTION="Bash in AWS Lambda version $GIT_VER [https://github.com/kayac/bash-lambda-layer]
published at $DATE
"

# AWS Regions
REGIONS=(
    "us-west-1"
    "us-west-2"
    "us-east-1"
    "us-east-2"
    "ap-south-1"
    "ap-northeast-1"
    "ap-northeast-2"
    "ap-southeast-1"
    "ap-southeast-2"
    "ca-central-1"
    "eu-central-1"
    "eu-north-1"
    "eu-west-1"
    "eu-west-2"
    "eu-west-3"
    "sa-east-1"
)
LAYER_NAME="bash-al2"

for region in ${REGIONS[@]}; do
    echo "Publishing layer to $region..."

    LAYER_ARN=$(aws lambda publish-layer-version --region $region --layer-name $LAYER_NAME --description "$DESCRIPTION" --compatible-runtimes provided.al2 --license MIT --zip-file fileb://export/layer.zip | jq -r .LayerVersionArn)
    POLICY=$(aws lambda add-layer-version-permission --region $region --layer-name $LAYER_NAME --version-number $(echo -n $LAYER_ARN | awk -F':' '{print $8}') --statement-id $LAYER_NAME-public --action lambda:GetLayerVersion --principal \*)

    echo $LAYER_ARN
    echo "$region complete"
    echo ""
done

echo "Successfully published to all regions"
