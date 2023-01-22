#!/usr/bin/env bash

echo "I'm going to create a new environment from you,using the skeleton template."
echo "Let me know which is the environment name you want: "

read ENV
CLEAN_ENV_NAME=${ENV//[^a-zA-Z0-9]/}
echo "New environment name will be $CLEAN_ENV_NAME"

if [ -d "tf/envs/${CLEAN_ENV_NAME}" ]; then
  # Take action if $DIR exists. #
  echo "${DIR} folder already exists! Stop"
  exit 1
else
    mkdir tf/envs/${CLEAN_ENV_NAME}
    cp -r tf/template/* ./tf/envs/${CLEAN_ENV_NAME}
    find tf/envs/${CLEAN_ENV_NAME} -type f -exec sed -i "s/skeleton/${CLEAN_ENV_NAME}/g" {} +
    echo "Environment $CLEAN_ENV_NAME created!"
    echo "Remember to change whatever is required in config.yaml"
    echo "Vault tokens, vault policies, passwords..."
    exit 0
fi
