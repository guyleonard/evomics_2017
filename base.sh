#!/usr/bin/env bash
set -x # debugging on
set -e # exit if command exits with non-zero status

## This script will do everything it can with apt-get and then switch to ansible
# for other programs/software that need installing, intersperced with generic
# unix utilities, git and possibly hombrew and conda.

# Working Directory
working_dir=$(pwd)

## Genereal Updates
# Update Apt Repositories
sudo apt-get update
# Upgrade everything to latest versions
sudo apt-get -y upgrade && sudo apt-get dist-upgrade

## Java - We may need both openjdk and Oracle versions
# default java - open java
apt-get -y install default-jre default-jdk
# Oracle Java
add-apt-repository ppa:webupd8team/java
apt-get update
apt-get -y install oracle-java8-installer
### Need to find an automated way to do this...
#update-alternatives --config java

# Development Software/Libraries









# turn off
set +x
set +e
