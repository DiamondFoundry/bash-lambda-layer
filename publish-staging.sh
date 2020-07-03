#!/bin/bash -e
GIT_VER=$(git describe --tags)
DATE=$(date +%Y-%m-%dT%H:%M:%S%z)
DESCRIPTION="Bash in AWS Lambda version $GIT_VER [https://github.com/kayac/bash-lambda-layer]
published in $DATE
"

# AWS Regions
REGIONS=(
    "${AWS_REGION:?no-region}"
)
LAYER_NAME="bash-testing"

for region in ${REGIONS[@]}; do
    echo "Publishing layer to $region..."

    LAYER_ARN=$(aws lambda publish-layer-version --region $region --layer-name $LAYER_NAME --description "$DESCRIPTION" --compatible-runtimes provided --license MIT --zip-file fileb://export/layer.zip | jq -r .LayerVersionArn)

    echo $LAYER_ARN
    echo "$region complete for Staging"
    echo ""
done

echo "Successfully published to all regions"
