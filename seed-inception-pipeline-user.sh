#!/bin/bash

reset

read -p 'AWS Account: ' awsaccount

if [ -z "$awsaccount" ]
then
    echo "You must provide the AWS Account number to use"
    exit 1
fi

read -p "AWS CLI profile (default is 'default'): " awsprofile

if [ -z "$awsprofile" ]
then
    awsprofile='default'
fi

aws --profile ${awsprofile} iam create-policy --policy-name InceptionPipelineSeedingPolicy --description "Minimum permissions required to seed an Inception Pipeline, and optionally delete it if required." --policy-document https://raw.githubusercontent.com/MechanicalRock/InceptionPipeline/post/part-6/policy.json
aws --profile ${awsprofile} iam create-user --user-name InceptionPipelineSeedingUser
aws --profile ${awsprofile} iam attach-user-policy --user-name InceptionPipelineSeedingUser --policy-arn "arn:aws:iam::${awsaccount}:policy/InceptionPipelineSeedingPolicy"
aws --profile ${awsprofile} iam create-access-key --user-name InceptionPipelineSeedingUser
