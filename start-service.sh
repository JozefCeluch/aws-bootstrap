#!/bin/bash -xe
source /home/ec2-user/.bash_profile
cd /home/ec2-user/app/release

# query the EC2 metadata service for this instance's region
REGION=`curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq .region -r`
# query the EC2 metadata service for this instance's instance-id
export INSTANCE_ID=`curl -s http://169.254.169.254/latest/meta-data/instance-id`
# query the EC2 describeTags method and pull CloudFormation logical ID for this instance
export STACK_NAME=`aws --region $REGION ec2 describe-tags \
    --filters "Name=resource-id,Values=${INSTANCE_ID}" \
              "Name=key,Values=aws:cloudformation:stack-name" \
    | jq -r ".Tags[0].Value"`

npm run start