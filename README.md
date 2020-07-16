# Bash in AWS Lambda  [Modified by Kayac inc.]

forked [gkrizek/bash-lambda-layer](https://github.com/gkrizek/bash-lambda-layer) because we needed to modify and maintain it in our organization.
See the [original REDME](README.original.md) for details.
Respect for the original gkrizek/bash-lambda-layer.

## Difference from the original

### ARN

```
arn:aws:lambda:<region>:513375597510:layer:bash:2
```

### tools version
* AWS CLI v2.0.30
* kv2json v0.02

### function
* Error handling using kv2json.

## How to publish to local AWS account.

Download the release package and do one of the following

### publish to All region

```
$ ./publish.sh
```

### publish to Single region

```
$AWS_REGION=<target region> ./publish-only.sh
```
