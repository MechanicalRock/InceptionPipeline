#!/bin/bash

# script to convert Codepipeline format parameters to cloudformation stack parameter files
# usage:
#   $ cat codepipeline-params.json | to-cfn-params.sh
# 
# uses JQ if available, otherwise uses awk

LOCAL_JQ=`which jq`
QUERY=".Parameters|to_entries|map({ParameterKey:(.key),ParameterValue:(.value)})"
JQ_CMD="jq -r $QUERY"

AWK_SCRIPT='BEGIN { FS = "[:,]"; OFS = ":" }
    /^\{/ { print "[" }
    /^\}/ { print "  }\n]" }
    ! /[\{\}]/ { gsub(/^[ \t]+/,"",$1);
        if (in_list) {print "  },"}
        print "  {"; print "    \"ParameterKey\"", $1 ","; print "    \"ParameterValue\"", $2;
        in_list=1;
    }'

if [ -z "$LOCAL_JQ" ]; then
    awk -e "$AWK_SCRIPT" <&0
else
    # Need to buffer into single line
    while read stdin; do JSON=$JSON$stdin ; done
    echo "$JSON" | $JQ_CMD
fi

