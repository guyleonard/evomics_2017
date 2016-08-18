#!/usr/bin/env bash
set -x # debugging on
set -e # exit if command exits with non-zero status

## This script will do everything it can with apt-get and then switch to ansible
# for other programs/software that need installing, intersperced with generic
# unix utilities, git and possibly hombrew and conda.

# Working Directory
working_dir=$(pwd)

## Ansible
# Setup Ansible
sudo apt-get install -y git python-pip python-dev python-cffi libssl-dev
sudo -H pip install --upgrade pip
sudo -H pip install ansible

# Clone the Evomics 2017 github repo
git clone https://github.com/guyleonard/evomics_2017.git
#
# run the base playbook
ansible-playbook /home/ubuntu/evomics_2017/base/base.yaml --sudo -K -c local -i "localhost,"


## Genereal Updates
# Update apt repositories
sudo apt-get update
# Upgrade everything to latest versions
sudo apt-get -y upgrade && sudo apt-get dist-upgrade


## Java - We may need both openjdk and Oracle versions
# default java - open java
#apt-get -y install default-jre default-jdk
# Oracle Java
#add-apt-repository ppa:webupd8team/java
#apt-get update
#apt-get -y install oracle-java8-installer
### Need to find an automated way to do this...
#update-alternatives --config java

# Development Software/Libraries









# turn off
set +x
set +e
