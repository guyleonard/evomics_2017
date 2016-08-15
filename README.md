# Evomics 2017
Instructions and notes for creating the AMIs for the evomics.org Workshops 2017

## Preamble
For the past two years I have created the AMIs for the Workshop on Genomics.

### 2015
I used a copy of [Bio-Linux 8](http://environmentalomics.org/bio-linux/) as the base AMI on which to base the workshop machine image (WMI). This was fine back in 2014, but it hasn't really be updated since July of that year and doesn't look like it's going to be continued, similarly (CloudBioLinux](http://cloudbiolinux.org/) isn't really mainted either.

### 2016
This year I decided to use the image [ami-a75e12cd](https://console.aws.amazon.com/ec2/home?region=us-east-1#LaunchInstanceWizard:ami=ami-a75e12cd) which is a copy of Ubuntu Server Wily 15.10.

## Base AMI
Again we will be using Ubuntu Linux as our base AMI in this case [ami-cf68e0d8](https://console.aws.amazon.com/ec2/home?region=us-east-1#LaunchInstanceWizard:ami=ami-cf68e0d8) which is the 'us-east-1'	copy of Ubuntu Xenial Xerus 16.04 LTS.

### Storage & Virtualisation Type
It can be quite a confusing mess of choices, but Amazon has some guides [here](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ComponentsAMIs.html) and we will be using:
 * HVM - Hardware Virtual Machine (as opposed to ParaVirtual -PV)
 * EBS - Elastic Block Storage (as opposed to Instance Store)


