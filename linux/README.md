# Ansible

Ansible repository for provisioning Tomcat Java Apps

## Getting Started
### Prerequisites

* python >= 3.8.5
* ansible >= 2.9.13
* molecule >= 3.0.8
* molecule-vagrant >= 0.3

### Diagram of workflow

Packer Ansible -> AMI -> Terraform (Launch Template and Auto Scaling Group )

## Molecule
We are using Ansible Molecule for development and testing our Ansible roles. With Molecule you can have test the Ansible roles with many different drivers like Docker, OpenStack and Vagrant. For environment consistency with bringing up AWS EC2s, we are going to be using the the Vagrant driver.

## Ansible Inventory structure

### Running Locally
#### Running molecule locally
Every role you create should be ran through Molecule for the full test converge

1. Change into the roles directory and run the following command to create a new role

      `molecule init role rolename`

2. Once you are in the directory you can run your molecule command of your choosing

      `molecule test`

#### Running Packer Ansible to create AMI

### What if you already have an role and just want to add molecule?
1. To be able to run molecule on an existing role you will need to run the following command in the role you want to initialize in
      `molecule init scenario -r rolename`

## Documentation

* [Molecule](https://molecule.readthedocs.io/en/latest/getting-started.html) - Documentation

## Addition information
