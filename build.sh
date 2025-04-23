#!/bin/bash

if [[ -z $ANSIBLE_GALAXY_SERVER_CERTIFIED_TOKEN || -z $ANSIBLE_GALAXY_SERVER_VALIDATED_TOKEN ]]
then
    echo "Set the following environment variables with a valid Automation Hub token before continuing"
    echo "export ANSIBLE_GALAXY_SERVER_CERTIFIED_TOKEN=<token>"
    echo "export ANSIBLE_GALAXY_SERVER_VALIDATED_TOKEN=<token>"
    exit 1
fi

if ! podman login --get-login registry.redhat.io
then
    echo "Run 'podman login registry.redhat.io' before continuing"
    exit 1
fi

rm -rf ./context/*
ansible-builder build \
    --file execution-environment.yml \
    --context ./context \
    --build-arg ANSIBLE_GALAXY_SERVER_CERTIFIED_TOKEN \
    --build-arg ANSIBLE_GALAXY_SERVER_VALIDATED_TOKEN \
    -v 3 \
    -t quay.io/jce-redhat/hashi-demo-ee:$(date +%Y%m%d) -v 3 | tee ansible-builder.log

