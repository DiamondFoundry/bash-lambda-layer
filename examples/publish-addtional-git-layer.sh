#!/bin/bash -e

mkdir -p layer
docker run --rm -v $(PWD)/layer:/lambda/opt lambci/yumda:2 yum install -y git
cd layer && zip -yr layer.zip * && cd ../
aws lambda publish-layer-version \
        --region ${AWS_REGION} \
        --layer-name bash-lambda-layer-example-git-layer \
        --description "bash-lambda-layer example additional layer for git" \
        --compatible-runtimes provided.al2 \
        --license MIT \
        --zip-file fileb://layer/layer.zip > additional-git-layer-publish-result.json
GIT_LAYER_ARN=$(cat additional-git-layer-publish-result.jso | jq -r .LayerVersionArn)
echo ${GIT_LAYER_ARN}
rm -rf layer
