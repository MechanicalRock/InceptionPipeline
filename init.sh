#!/bin/bash
set -e
reset

# Update to use a different AWS profile
PROFILE=default
STACK_NAME=@@StageAdministerPipelineStackName@@

echo "Create the initial CloudFormation Stack"
aws --region us-east-1 --profile ${PROFILE} cloudformation create-stack --stack-name ${STACK_NAME} --template-body file://aws_seed.yml --parameters file://aws_seed-cli-parameters.json --capabilities "CAPABILITY_NAMED_IAM"
echo "Waiting for the CloudFormation stack to finish being created."
aws --region us-east-1 --profile ${PROFILE} cloudformation wait stack-create-complete --stack-name ${STACK_NAME}
# Print out all the CloudFormation outputs.
aws --region us-east-1 --profile ${PROFILE} cloudformation describe-stacks --stack-name ${STACK_NAME} --output table --query "Stacks[0].Outputs"

export CODECOMMIT_REPO=`aws --region us-east-1 --profile ${PROFILE} cloudformation describe-stacks --stack-name ${STACK_NAME} --output text --query "Stacks[0].Outputs[?OutputKey=='CodeCommitRepositoryCloneUrlHttp'].OutputValue"`

echo "Initialising Git repository"
git init
echo "Adding the newly created CodeCommit repository as origin"
git remote add origin ${CODECOMMIT_REPO}
echo "Adding all files"
git add .
echo "CodeCommitting files"
git commit -m "Initial commit"
echo "Pushing to CodeCommit"
git push --set-upstream origin master
