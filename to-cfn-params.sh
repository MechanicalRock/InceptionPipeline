#!/bin/bash

# script to convert Codepipeline format parameters to cloudformation stack parameter files
# usage:
#   $ cat codepipeline-params.json | to-cfn-params.sh
# 
# uses JQ locally if available, otherwise downloads it via docker image

LOCAL_JQ=`which jq`
QUERY=".Parameters|to_entries|map({ParameterKey:(.key),ParameterValue:(.value)})"
JQ_CMD="jq -r $QUERY"

while read stdin; do JSON=$JSON$stdin ; done

if [ -z "$LOCAL_JQ" ]; then
    docker run -t --rm --name jq endeveit/docker-jq \
        sh -c "echo '$JSON' |jq -r '$QUERY'"
else
    echo "$JSON" | $JQ_CMD
fi

