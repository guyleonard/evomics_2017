# Evomics 2017
Instructions and notes for creating the AMIs for the [evomics.org](http://evomics.org) Workshops 2017 and information on the previous years' AMIs in [previous_workflow.md].

## Preamble
For the past two years I have created the AMIs for the Workshop on Genomics a couple of weeks prior to the workshops beginning - usually in my Christmas holiday and also during the Faculty set up week. 2014 was the first time that I had ever used Amazon EC2 and an AMI, let alone been tasked to create one of my own and so I wanted it to work the first time! Therefore, in that first year I decided to use a copy of BioLinux which helped expedite the process of installing software (their repositories already included many of the bioinformatics software we needed) but it is not really maintained that well anymore. Nevertheless it worked, and it was relatively stable. So, success!

In the second year I decided to install everything from scratch (well other than the base OS), so now more than a novice at using Amazon's webs services it was easy for me, but it's a bit of a laborious and slow process. It was very stable, and I can't remember any problems other than one with Stacks that was human error. The AMI was split half-way and used - I think - as a base to the Population and Speciation Genomics workshop by Adam Bazinet.

This year I want to try and get the building of the AMI to be as automated as possible. If I can use technology to help me automate the process, then all I need to do is press 'go' and come back later and double check it all completed (obviously so that I can go and drink more Czech Lager - surely the reason for anyone to become a bioinformatician; automate it = drink more). This will allow changes to be made to the install scripts and if anything breaks, a new AMI can be started from scratch, rather than keeping intermediate copies as I have in the past.

# 2017 Workshops (Genomics & Phylogenomics)

## Automation

For this we are going to use a series of shell scripts, [Ansible]() and a few other package managers such as apt-get, pip, conda, and gem. You may also wish to read [ami_changes.md]

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
