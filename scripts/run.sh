#!/usr/bin/env bash
docker build services/account -t form3tech-oss/platformtest-account
docker build services/gateway -t form3tech-oss/platformtest-gateway
docker build services/payment -t form3tech-oss/platformtest-payment
docker-compose -p form3_test up -d
echo Applying terraform script
pushd ./tf
terraform init -upgrade
terraform apply -auto-approve
popd
