#!/bin/bash -e

mkdir -p /tmp/pip3pkg
cd /tmp/pip3pkg && \
    pip3 install awscli -t . && \
    rm -rf *.dist-info  && \
    mv bin/aws . && \
    sed -i -e 's/#!\/var\/lang\/bin\/python3\.6/#!\/usr\/bin\/python3/g' aws
    rm -rf bin && \
    rm -rf __pycache__ && \
    rm -rf */__pycache__ && \

ls -1 /tmp/pip3pkg | xargs -t -I{} rm -rf /root/bash-lambda-layer/bin/{}
cp -r /tmp/pip3pkg/* /root/bash-lambda-layer/bin/
