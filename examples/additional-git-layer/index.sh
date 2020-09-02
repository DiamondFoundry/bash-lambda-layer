function handler {
    set -e
    AWS_VERSION=$(aws --version)
    JQ_VERSION=$(jq --version)
    GIT_VERSION=$(git --version)

    OUTPUT=$( \
        jq -n \
            --arg awsVersion "$AWS_VERSION" \
            --arg jqVersion "$JQ_VERSION" \
            --arg gitVersion "$GIT_VERSION" \
            '{aws: $awsVersion, jq: $jqVersion, git: $gitVersion}'
    )
    echo "${OUTPUT}" >&2
}
