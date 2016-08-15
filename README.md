# Evomics 2017
Instructions and notes for creating the AMIs for the evomics.org Workshops 2017

## Preamble
For the past two years I have created the AMIs for the Workshop on Genomics. It was the first time I had to use Amazon EC2 and their AMIs, let alone to create one of my own! In the first year I decided to use a copy of BioLinux which helped expedite the process of installing software (their repositories already include bioinformatics software)- but it's not really maintained all that well. In the second year I decided to install everything by hand and from scratch. Easy, but laborious and slow. This year I want it to be automated as much as possible.

## Previous Years
### 2015
I used a copy of [Bio-Linux 8](http://environmentalomics.org/bio-linux/) as the base AMI on which to base the workshop machine image (WMI). This was fine back in 2014, but it hasn't really be updated since July of that year and doesn't look like it's going to be continued [link](), similarly (CloudBioLinux](http://cloudbiolinux.org/) isn't really mainted either and hasn't been updated since 2013.

### 2016
I decided to use the image [ami-a75e12cd](https://console.aws.amazon.com/ec2/home?region=us-east-1#LaunchInstanceWizard:ami=ami-a75e12cd) which is a copy of Ubuntu Server Wily 15.10 due to the lack of updates on BioLinux platforms.
#### Caveat
As I will mention elsewhere, this is a Server version of Linux - that means no Desktop interface just the shell. It needs to be installed separately as some workshop material relies on a GUI and some students prefer it as an environment to start with.

## Previous Workflow
Usually I would start with a base AMI and as I got the lists of programs, dependencies and software packages from the Faculty I would install them.

# 2017 Workshops (Genomics & -----genomics)


## 2017 Base AMI
Again we will be using Ubuntu Linux as our base AMI in this case [ami-cf68e0d8](https://console.aws.amazon.com/ec2/home?region=us-east-1#LaunchInstanceWizard:ami=ami-cf68e0d8) which is the 'us-east-1'	copy of Ubuntu Xenial Xerus 16.04 LTS.

### Storage & Virtualisation Type
It can be quite a confusing mess of choices, but Amazon has some guides [here](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ComponentsAMIs.html) and we will be using:
 * HVM - Hardware Virtual Machine (as opposed to ParaVirtual -PV)
 * EBS - Elastic Block Storage (as opposed to Instance Store)


