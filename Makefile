SHELL = /usr/bin/env bash -xe

PWD := $(shell pwd)

build:
	@rm -rf export
	@mkdir export
	@zip -yr export/layer.zip bootstrap bin lib libexec share

publish:
	@$(PWD)/publish.sh

publish-staging:
	@$(PWD)/publish-staging.sh

update-awscli:
	docker run -it -v $(PWD):/root/bash-lambda-layer \
		lambci/lambda:build-python3.6 \
		bash -c /root/bash-lambda-layer/update-awscli.sh


.PHONY: \
	build
	publish
	publish-staging
