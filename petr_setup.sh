#!/bin/bash
# Simple bash for Workshop C9 Deployment.
# will move towards real automation tools later on
# created by David Surey, Amazon Web Services
# suredavi@amazon.de
# NOT FOR PRODUCTION USE - Only for Workshop purposes

C9STACK="SoloWorkshop-431"
REGION=$1
PROFILE=$2
ENV_TYPE=$3
ROLE_ARN=$4

if ! [ -x "$(command -v aws)" ]; then
  echo 'Error: aws cli is not installed.' >&2
  exit 1
fi

if [ ! -z "$PROFILE" ]; then
  export AWS_PROFILE=$PROFILE
fi

if [ ! -z "$REGION" ]; then
  export AWS_DEFAULT_REGION=$REGION
fi

if [ "$ENV_TYPE" == "3rdParty" ] && [ -z "$ROLE_ARN" ]; then
  echo 'Error: For 3rdParty environment type, ROLE_ARN must be provided.' >&2
  exit 1
else
  ENV_TYPE="self"
fi

echo "Building $PROFILE C9 in $ENV_TYPE mode"

# Build the C9 environment
if [ "$ENV_TYPE" == "3rdParty" ]; then
  aws cloudformation deploy \
    --stack-name $C9STACK \
    --capabilities CAPABILITY_IAM \
    --template-file ./petr_instancestack.yaml \
    --parameter-overrides ExampleC9EnvType=$ENV_TYPE ExampleOwnerArn=$ROLE_ARN
else
  aws cloudformation deploy \
    --stack-name $C9STACK \
    --capabilities CAPABILITY_IAM \
    --template-file ./petr_instancestack.yaml \
    --parameter-overrides ExampleC9EnvType=$ENV_TYPE
fi

exit 0
