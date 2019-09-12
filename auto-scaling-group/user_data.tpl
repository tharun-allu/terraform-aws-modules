#!/bin/bash -xe
exec 2>/tmp/userdata.log
sudo yum -y install aws-cfn-bootstrap
export PATH=/usr/local/bin:$PATH
yum -y --security update
easy_install pip
pip install awscli

/opt/aws/bin/cfn-signal -e 0 --region "${aws_region}" --stack "${name}" --resource "AutoScalingGroup"

