echo off
cls

echo Create the initial CloudFormation Stack
aws --profile default cloudformation create-stack --stack-name "@@StageAdministerPipelineStackName@@" --template-body file://aws_seed.yml --parameters file://aws_seed-cli-parameters.json --capabilities "CAPABILITY_NAMED_IAM" 
echo Waiting for the CloudFormation stack to finish being created.
aws --profile default cloudformation wait stack-create-complete --stack-name "@@StageAdministerPipelineStackName@@"
# Print out all the CloudFormation outputs.
aws --profile default cloudformation describe-stacks --stack-name "@@StageAdministerPipelineStackName@@" --output table --query "Stacks[0].Outputs"

for /f %%CODECOMMIT_REPO in ('aws --profile default cloudformation describe-stacks --stack-name "@@StageAdministerPipelineStackName@@" --output text --query "Stacks[0].Outputs[?OutputKey=='CodeCommitRepositoryCloneUrlHttp'].OutputValue"') do set VAR=%%CODECOMMIT_REPO

echo Initialising Git repository
git init
echo Adding the newly created CodeCommit repository as origin
git remote add origin %CODECOMMIT_REPO%
echo Adding all files
git add .
echo CodeCommitting files
git commit -m "Initial commit"
echo Pushing to CodeCommit
git push --set-upstream origin master
