#!/bin/bash -e
GIT_VER=$(git describe --tags)
DATE=$(date +%Y-%m-%dT%H:%M:%S%z)
DESCRIPTION="Bash in AWS Lambda version $GIT_VER [https://github.com/kayac/bash-lambda-layer]
published at $DATE
"

# AWS Regions
region=${AWS_REGION:?no-region}
LAYER_NAME="bash-al2"

echo "Publishing layer to $region..."

LAYER_ARN=$(aws lambda publish-layer-version --region $region --layer-name $LAYER_NAME --description "$DESCRIPTION" --compatible-runtimes provided.al2 --license MIT --zip-file fileb://export/layer.zip | jq -r .LayerVersionArn)
if [ -n "$PERMISSION" ]; then
    POLICY=$(aws lambda add-layer-version-permission \
        --region $region \
        --layer-name $LAYER_NAME \
        --version-number $(echo -n $LAYER_ARN | awk -F':' '{print $8}') \
        --statement-id $LAYER_NAME-public \
        --action lambda:GetLayerVersion \
        $PERMISSION)
    echo $POLICY
fi

echo $LAYER_ARN
echo ""

echo "Successfully published to $region"
