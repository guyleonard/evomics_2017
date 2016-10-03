# Evomics 2017
Instructions and notes for creating the AMIs for the [evomics.org](http://evomics.org) Workshops 2017 and information on the previous years' AMIs.

## Preamble
For the past two years I have created the AMIs for the Workshop on Genomics a couple of weeks prior to the workshops beginning - usually in my Christmas holiday and also during the Faculty set up week. 2014 was the first time that I had ever used Amazon EC2 and an AMI, let alone been tasked to create one of my own and so I wanted it to work the first time! Therefore, in that first year I decided to use a copy of BioLinux which helped expedite the process of installing software (their repositories already included many of the bioinformatics software we needed) but it is not really maintained that well anymore. Nevertheless it worked, and it was relatively stable. So, success!

In the second year I decided to install everything from scratch (well other than the base OS), so now more than a novice at using Amazon's webs services it was easy for me, but it's a bit of a laborious and slow process. It was very stable, and I can't remember any problems other than one with Stacks that was human error. The AMI was split half-way and used - I think - as a base to the Population and Speciation Genomics workshop by Adam Bazinet.

This year I want to try and get the building of the AMI to be as automated as possible. If I can use technology to help me automate the process, then all I need to do is press 'go' and come back later and double check it all completed (obviously so that I can go and drink more Czech Lager - surely the reason for anyone to become a bioinformatician; automate it = drink more). This will allow changes to be made to the install scripts and if anything breaks, a new AMI can be started from scratch, rather than keeping intermediate copies as I have in the past.

## Previous Years
### 2015
I used a copy of [Bio-Linux 8](http://environmentalomics.org/bio-linux/) as the base AMI on which to base the workshop machine image. This was fine back in 2014, but it hasn't really been updated since July of that year and doesn't look like it's going to be continued [link](), similarly [CloudBioLinux](http://cloudbiolinux.org/) isn't really mainted either and hasn't been updated since 2013.
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
 * other repositories, updates, motds and customisations etc

# 2017 Workshops (Genomics & Phylogenomics)

## Automation

For this we are going to use a series of shell scripts, [Ansible]() and a few other package managers such as apt-get, pip, conda, and gem.

## Security Groups
You will also need to set up a bunch of open ports to allow through to your AMI. This will be for things like Apache, RStudio, SSH, X2Go, etc.

List:
 * XRDP - Remote Desktop
  * TCP:3389
 * RStudio
  * TCP: 8787
 * SSH
  * TCP: 22
 * Web
  * TCP: 8080 & TCP: 8888

## Passwords

In this README and throughout some of the playbooks and taskbooks you will find paswords, with the exception of the mysql password (SHA1), they are all written in the SHA-512 hashed representation.
I won't be including what the hashes translate to - i.e. the plain text passwords here. Therefore, if you fork this repository or want to try it out for yourself, you should change the passwords.
There are three users to change: genomics, phylogenomics, master and one mysql password to change.

### Generate Crypted Passwords for Users
    mkpasswd --method=sha-512

### Generate Crypted Password for MySql
    SELECT PASSWORD("password")

## 2017 Base AMI
We will be using the latest Ubuntu Linux as our initial AMI, in this case: [ami-cf68e0d8](https://console.aws.amazon.com/ec2/home?region=us-east-1#LaunchInstanceWizard:ami=ami-cf68e0d8) which is the 'us-east-1'	copy of Ubuntu Xenial Xerus 16.04 LTS.

### Storage & Virtualisation Type
It can be quite a confusing mess of choices, but Amazon has some guides [here](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ComponentsAMIs.html) and so we will be using:
 * HVM - Hardware Virtual Machine (as opposed to ParaVirtual -PV)
 * EBS - Elastic Block Storage (as opposed to Instance Store)

## Base AMI Minor Changes and Updates
* Password SSH login for users below
* user: admin (general connections to an AMI use a key-pair but we don't use this during the workshop as it has passwordless sudo and it's one less thing to worry about the students having an issue with).
 * password:
* Disable Update Checker
* Disable overlay scrollbars
* [MOSH](https://mosh.org/) - just in case, but SSH is usually stable
* apt-get update, upgrade, dist-upgrade
* MATE Desktop
* X2Go
* Java - install both OpenJDK and Oracle, set to Oracle - [here](https://www.digitalocean.com/community/tutorials/how-to-install-java-with-apt-get-on-ubuntu-16-04)
* Useful tools/programs
 * apache2 arj build-essential cabextract cowsay cowthink curl file-roller filezilla fortune gimp git inkscape libapache2-mod-php libreoffice-base libreoffice-calc libreoffice-core mpack  mysql-client mysql-server p7zip p7zip-rar php php-mcrypt php-mysql qbittorrent rar rev samba sharutils unace unrar unzip uudeview xcowsay zip
 * chrome, firefox
 * gem install lolcat
 * export PS1="\[\033[38;5;220m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\]@\[$(tput sgr0)\]\[\033[38;5;39m\]\h\[$(tput sgr0)\]\[\033[38;5;15m\]:\[$(tput sgr0)\]\[\033[38;5;202m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\]\\$ \[$(tput sgr0)\]"
 * R and RStudio Desktop+Server
 
## Genomics Specific
 * Background Wallpaper
 * user: genomics
  * password: $6$xsb/UrhJ$sxievieZ7erTF93MwiBEZqm/mIpTVlTd3uhYGY2Urt5qoGapG3ZEU6NrGMOYd7QUnFfXhgDn12OPxDuxb20dB0
 * bioconda
All other software can be found in the 'genomics' task folder and playbooks.

## Phylogenomics Specific
* Background Wallpaper
* user: phylogenomics
 * password: $6$xsb/UrhJ$sxievieZ7erTF93MwiBEZqm/mIpTVlTd3uhYGY2Urt5qoGapG3ZEU6NrGMOYd7QUnFfXhgDn12OPxDuxb20dB0 
All other software can be found in the 'genomics' task folder and playbooks.

# Using This Repository
To build the AMI for either workshop, you will need to run at least the [base.sh](https://github.com/guyleonard/evomics_2017/blob/master/base.sh) script on your remote Virtual Machine and then one or the other of the sets of "genomics_workshop_*.yaml" and "phylogenomics_workshop_*.yaml".

These scripts will run the Ansible 'Playbooks' which are a serious of instructions and 'taskbooks' to automate the install of software, workshop materials and other settings which are described above in [2017 Base AMI](https://github.com/guyleonard/evomics_2017#2017-base-ami) section and probably some I have forgotten to list, but you can see them in the code...

## Base AMI Setup

Run this code on your clean AMI:

    wget -O- https://raw.githubusercontent.com/guyleonard/evomics_2017/master/setup.sh | bash

I would now make an Amazon Image of this system and then use that as your "base AMI" for the next steps...

If you already have a base-AMI you wish to use.

    git clone https://github.com/guyleonard/evomics_2017.git
    ansible-playbook /home/ubuntu/evomics_2017/base/base.yaml -b -K -c local -i "localhost,"

## Genomics AMI Setup:

### Software

    ANSIBLE_NOCOWS=1 ansible-playbook /home/ubuntu/evomics_2017/genomics/genomics_workshop_software.yaml -b -K -c local -i "localhost,"

or for just two tools, e.g. samtools & bwa:

    ANSIBLE_NOCOWS=1 ansible-playbook /home/ubuntu/evomics_2017/genomics/genomics_workshop_software.yaml -b -K -c local -i "localhost," --tags samtools,bwa
    
or for just one tutorial you could do:

    ANSIBLE_NOCOWS=1 ansible-playbook /home/ubuntu/evomics_2017/genomics/genomics_workshop_software.yaml -b -K -c local -i "localhost," --tags assembly

### Data

## Phylogenomics AMI Setup
