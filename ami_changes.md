# Security Groups
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

# Passwords

In this README and throughout some of the playbooks and taskbooks you will find paswords, with the exception of the mysql password (SHA1), they are all written in the SHA-512 hashed representation.
I won't be including what the hashes translate to - i.e. the plain text passwords here. Therefore, if you fork this repository or want to try it out for yourself, you should change the passwords.
There are three users to change: genomics, phylogenomics, master and one mysql password to change.

## Generate Crypted Passwords for Users
    mkpasswd --method=sha-512

## Generate Crypted Password for MySql
    SELECT PASSWORD("password")

# 2017 Base AMI
We will be using the latest Ubuntu Linux as our initial AMI, in this case: [ami-cf68e0d8](https://console.aws.amazon.com/ec2/home?region=us-east-1#LaunchInstanceWizard:ami=ami-cf68e0d8) which is the 'us-east-1'	copy of Ubuntu Xenial Xerus 16.04 LTS.

## Storage & Virtualisation Type
It can be quite a confusing mess of choices, but Amazon has some guides [here](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ComponentsAMIs.html) and so we will be using:
 * HVM - Hardware Virtual Machine (as opposed to ParaVirtual -PV)
 * EBS - Elastic Block Storage (as opposed to Instance Store)

# Base AMI Minor Changes and Updates
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
