#!/bin/bash
echo "packer build -machine-readable packer-helpy.json"
ARTIFACT=`packer build -machine-readable packer-helpy.json | awk -F, '$0 ~/artifact,0,id/ {print $6}'`
AMI_ID=`echo $ARTIFACT |cut -d ':' -f2|cut -d ' ' -f2`
echo 'variable "AMI_ID" { default = "'${AMI_ID}'" }' > amivar.tf
echo "AMI ID = ${AMI_ID}"
