# Bash in AWS Lambda  [Modified by Kayac inc.]

forked [gkrizek/bash-lambda-layer](https://github.com/gkrizek/bash-lambda-layer) because we needed to modify and maintain it in our organization.
Respect for the original gkrizek/bash-lambda-layer.

The original gkrizek/bash-lambda-layer is no longer supported on August 20, 2020.
Click [here](https://github.com/gkrizek/bash-lambda-layer/commit/703b0ade8174022d44779d823172ab7ac33a5505) for details.

## Difference from the original

### compatible runtimes
only `provided.al2`

### ARN

```
arn:aws:lambda:<region>:513375597510:layer:bash:4
```

### tools version
In kayac/bash-lambda-layer,the following executables.
* AWS CLI v2.0.30
* jq 1.6
* zip 3.0
* unzip 6.0

### function
* Error handling using jq, for json escape.

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

## If want additional executable commands...

Let's stack layers
Check `examples/additional-git-layer` for more details.

Only add executables to kayac/bash-lambda-layer if it is often needed by our organization.
