#!/usr/bin/env bash

sudo yum install -y docker 
sudo service docker start 
sudo usermod -aG docker ec2-user 

sudo docker build -t maceproject:latest .
sudo docker run -it maceproject bash