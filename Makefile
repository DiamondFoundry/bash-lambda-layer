SHELL = /usr/bin/env bash -xe

PWD := $(shell pwd)

build_on_docker:
	docker build -t bash-lambda-layer-builder docker/builder
	docker run -it -v $(PWD):/root/bash-lambda-layer -v $(PWD)/bin:/opt/bin \
		--workdir="/root/bash-lambda-layer" \
		bash-lambda-layer-builder \
		make build

build: bin/kv2json bin/aws
	@rm -rf export
	@mkdir export
	@zip -yr export/layer.zip bootstrap bin lib libexec share

packages: build
	@zip -yr export/bash-lambda-layer.zip export/layer.zip publish.sh publish-only.sh README.publish.md

publish:
	@$(PWD)/publish.sh

publish-staging:
	@$(PWD)/publish-staging.sh

publish-only:
	@$(PWD)/publish-only.sh

# https://docs.aws.amazon.com/lambda/latest/dg/runtimes-walkthrough.html
# Custom runtimes are deployed in the /opt/ directory.
# AWS CLI v2 install path is /opt/bin/awscli
bin/aws:
	cd /tmp \
		&& curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
		&& unzip awscliv2.zip \
		&& rm -rf ./aws/dist/awscli/examples \
		&& ./aws/install -i /opt/bin/awscli -b /opt/bin --update \
		&& rm -f awscliv2.zip \
		&& rm -rf aws

bin/kv2json:
	cd bin/ \
		&& curl -sOL https://raw.githubusercontent.com/Songmu/App-KV2JSON/master/kv2json \
		&& chmod +x kv2json

clean:
	rm -f bin/aws
	rm -rf bin/awscli
	rm -f bin/aws_completer
	rm -f bin/kv2json

.PHONY: \
	build
	publish
	publish-staging
