# Evomics 2017
Instructions and notes for creating the AMIs for the [evomics.org](http://evomics.org) Workshops 2017 and information on the previous years' AMIs in [previous_workflow.md](https://github.com/guyleonard/evomics_2017/blob/master/previous_workflow.md).

## Preamble
For the past two years I have created the AMIs for the Workshop on Genomics a couple of weeks prior to the workshops beginning - usually in my Christmas holiday and also during the Faculty set up week. This year I want to try and get the building of the AMI to be as automated as possible ahead of the workshop. This will also allow students, faculty, PIs, etc, to build/alter their own copies for future workshops, training or personal use. If you plan to make changes for your own use, I highly suggest forking this repository and making changes to your copy. I am happy to accept pull requests for software bugs, updates, fixes, additions etc.

# 2017 Workshops (Genomics & Phylogenomics)

## Automation

For this we are going to use a series of shell scripts, [Ansible]() and a few other package managers such as apt-get, pip, conda, and gem. You may also wish to read [ami_changes.md](https://github.com/guyleonard/evomics_2017/blob/master/ami_changes.md). Ansible is a simple piece of automation software you can use to install programs and manage systems. You can see what is happening in each stage by looking in the 'main\_\*.yaml' file (or playbook) for each section (e.g. base, genomics, phylogenomics), it is a plain text file with a list of instructions to install programs, change files, download data etc. Some of these instructions are broken into smaller components called taks (e.g. the Assembly Tutorial from the Workshop on Genomics is a series of programs and files to be installed) and they can be found in the sub-folder "tasks" in each workshop.

# Using This Repository
To build the AMI for either workshop, you will need to run at least the [base.sh](https://github.com/guyleonard/evomics_2017/blob/master/base.sh) script on your remote Virtual Machine, and then one or the other or both of the sets of "main\_\*.yaml" playbooks from each workshop.

These scripts will run the Ansible 'Playbooks' which are a serious of instructions and 'taskbooks' to automate the install of software, workshop materials and other settings which are described above in [2017 Base AMI](https://github.com/guyleonard/evomics_2017#2017-base-ami) section and probably some I have forgotten to list, but you can see them in the code...

## Base AMI Setup

Run this code on your clean AMI:

    wget -O- https://raw.githubusercontent.com/guyleonard/evomics_2017/master/setup.sh | bash

I would now make an Amazon Image of this system and then use that as your "base AMI" for the next steps...

If you already have a base-AMI you wish to use.

    git clone https://github.com/guyleonard/evomics_2017.git
    ansible-playbook /home/ubuntu/evomics_2017/base/main.yaml -b -K -c local -i "localhost,"

## Genomics AMI Setup:

### Software

    ANSIBLE_NOCOWS=1 ansible-playbook /home/ubuntu/evomics_2017/genomics/genomics_workshop_software.yaml -b -K -c local -i "localhost,"

or for just two tools, e.g. samtools & bwa:

    ANSIBLE_NOCOWS=1 ansible-playbook /home/ubuntu/evomics_2017/genomics/genomics_workshop_software.yaml -b -K -c local -i "localhost," --tags samtools,bwa
    
or for just one tutorial you could do:

    ANSIBLE_NOCOWS=1 ansible-playbook /home/ubuntu/evomics_2017/genomics/genomics_workshop_software.yaml -b -K -c local -i "localhost," --tags assembly

### Data

## Phylogenomics AMI Setup
