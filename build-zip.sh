#!/bin/bash
#
# Create a zip archive of the layer suitable to upload to AWS Lambda
#
zip -9ry bash-layer.zip bin lib libexec share bootstrap

