#!/bin/bash

cp dns.tf.norules dns.tf
terraform apply -auto-approve
sleep 10
terraform apply -auto-approve

cp dns.tf.rules dns.tf
terraform apply -auto-approve
