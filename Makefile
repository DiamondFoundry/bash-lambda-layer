SHELL = /usr/bin/env bash -xe
AWSCLI_VERSION := 2.0.30
JQ_VERSION := 1.6
PWD := $(shell pwd)

build_on_docker: archives/awscli-exe-linux-x86_64-$(AWSCLI_VERSION).zip
	docker build -t bash-lambda-layer-builder docker/builder
	docker run -v $(PWD):/root/bash-lambda-layer -v $(PWD)/bin:/opt/bin \
		--workdir="/root/bash-lambda-layer" \
		bash-lambda-layer-builder \
		make build

build: awscli bin/jq
	@rm -rf export
	@mkdir export
	@zip -yr export/layer.zip bootstrap bin lib libexec share
	@zip -yr export/bash-lambda-layer.zip export/layer.zip publish.sh publish-only.sh README.publish.md

publish:
	@$(PWD)/publish.sh

publish-staging:
	@$(PWD)/publish-staging.sh

publish-only:
	@$(PWD)/publish-only.sh

archives/awscli-exe-linux-x86_64-$(AWSCLI_VERSION).zip:
	aws s3 cp s3://kayac-bash-lambda-layer/archives/awscli-exe-linux-x86_64-$(AWSCLI_VERSION).zip archives/

# https://docs.aws.amazon.com/lambda/latest/dg/runtimes-walkthrough.html
# Custom runtimes are deployed in the /opt/ directory.
# AWS CLI v2 install path is /opt/bin/awscli
awscli: archives/awscli-exe-linux-x86_64-$(AWSCLI_VERSION).zip
	unzip -q archives/awscli-exe-linux-x86_64-$(AWSCLI_VERSION).zip -d /tmp
	cd /tmp \
		&& rm -rf ./aws/dist/awscli/examples \
		&& ./aws/install -i /opt/bin/awscli -b /opt/bin --update \
		&& rm -rf aws

bin/jq:
	cd bin/ \
		&& curl -o jq -sL https://github.com/stedolan/jq/releases/download/jq-$(JQ_VERSION)/jq-linux64 \
		&& chmod +x jq

clean:
	rm -f bin/aws
	rm -rf bin/awscli
	rm -f bin/aws_completer
	rm -f bin/kv2json
	rm -f archives/*.zip

.PHONY: \
	build
	publish
	publish-staging
	awscli
