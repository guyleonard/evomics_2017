# Evomics 2017
Instructions and notes for creating the AMIs for the [evomics.org](http://evomics.org) Workshops 2017 and information on the previous years' AMIs.

## Preamble
For the past two years I have created the AMIs for the Workshop on Genomics a couple of weeks prior to the workshops begining. 2014 was the first time that I had to use Amazon EC2 and their AMIs, let alone be tasked to create one of my own! In the first year I decided to use a copy of BioLinux which helped expedite the process of installing software (their repositories already include bioinformatics software) but it's not really maintained all that well anymore. But it worked, and it was relatively stable. In the second year I decided to install everything from scratch (well other than the base OS). Easy for me, but it's a bit laborious and a slow process. It was very stable, and I can't remember any problems other than one with Stacks that was human error. This year I want to try and get the building of the AMI to be as automated as possible. If I can use technology to help me automate the process, then all I need to do is press 'go' and come back later and double check it all installed. That way changes can be made to the install scripts and if anything breaks, a new AMI can be started from scratch, rather than keeping intermediate copies as I have in the past.

## Previous Years
### 2015
I used a copy of [Bio-Linux 8](http://environmentalomics.org/bio-linux/) as the base AMI on which to base the workshop machine image (WMI). This was fine back in 2014, but it hasn't really be updated since July of that year and doesn't look like it's going to be continued [link](), similarly (CloudBioLinux](http://cloudbiolinux.org/) isn't really mainted either and hasn't been updated since 2013.
 * [ami-4e89fa26](https://console.aws.amazon.com/ec2/home?region=us-east-1#LaunchInstanceWizard:ami=ami-4e89fa26)
 * username:
 * password:

### 2016
I decided to use the image [ami-a75e12cd](https://console.aws.amazon.com/ec2/home?region=us-east-1#LaunchInstanceWizard:ami=ami-a75e12cd) which is a copy of Ubuntu Server Wily 15.10 due to the lack of updates on BioLinux platforms. As I will mention elsewhere, this is a Server based version of Linux - that means there is no Desktop interface, just the shell. A Desktop GUI needs to be installed separately as some workshop material relies on a GUI and some students prefer it as an environment to start with. There aren't generally Desktop versions of Linux available on EC2.
 * [ami-2f6f3445](https://console.aws.amazon.com/ec2/home?region=us-east-1#LaunchInstanceWizard:ami=ami-2f6f3445)
 * username:
 * password:

## Previous Workflow
Usually I would start with a base AMI (e.g. BioLinux or Ubuntu) and as I got the lists of programs, dependencies and software packages from the Faculty I would install them. I would also set up a range of other things, including:
 * [MATE Desktop Environment](http://mate-desktop.com/) - this is the default in Ubuntu anyway but needs to be instaled on the server version.
 * [X2Go](http://wiki.x2go.org/doku.php) - Remote Desktop software which allows a graphical connection to the AMI much like NoMachine.
 * A stunning Workshop on Genomics desktop background.
 * Password enabled SSH Login and X-Forwarding
 * VNC & XRDP - last resort remote desktop interfaces for inevitable student laptop issues with X2Go.
 * other repositories and updates

# 2017 Workshops (Genomics & -----genomics)
## 2017 Base AMI
Again we will be using Ubuntu Linux as our base AMI in this case [ami-cf68e0d8](https://console.aws.amazon.com/ec2/home?region=us-east-1#LaunchInstanceWizard:ami=ami-cf68e0d8) which is the 'us-east-1'	copy of Ubuntu Xenial Xerus 16.04 LTS.
### Storage & Virtualisation Type
It can be quite a confusing mess of choices, but Amazon has some guides [here](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ComponentsAMIs.html) and we will be using:
 * HVM - Hardware Virtual Machine (as opposed to ParaVirtual -PV)
 * EBS - Elastic Block Storage (as opposed to Instance Store)


