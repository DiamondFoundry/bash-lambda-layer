
export AWS_REGION=ap-northeast-1

all: deploy/basic

tools:
	brew install fujiwara/tap/lambroll

deploy/%:
	cd $*/ && lambroll --region ${AWS_REGION} deploy

deploy/additional-git-layer: additional-git-layer-publish-result.json
	export GIT_LAYER_ARN=$(shell cat ./additional-git-layer-publish-result.json | jq -r .LayerVersionArn)
	cd additional-git-layer/ && lambroll --region ${AWS_REGION} deploy

additional-git-layer-publish-result.json:
	$(PWD)/publish-addtional-git-layer.sh

