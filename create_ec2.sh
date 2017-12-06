#!/bin/bash

##PRIVATE_KEY=pk-<id>.pem
##CERT_KEY=cert-<id>.pem
##REGION=eu-west-1

AMI=ami-0def3275
GROUP=defaultgrp
SECURITY_KEY=keyname
INSTANCE_TYPE=t1.micro


aws ec2 run-instances --image-id $AMI --instance-type $INSTANCE_TYPE  --count 1 --security-groups $GROUP --key-name $SECURITY_KEY




