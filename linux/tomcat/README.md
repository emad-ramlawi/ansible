### What is this role for? ###

* Installing tomcat role
* 0.2

### How do I get set up? ###

Download and run AL2 locally using your preferred hypervisor, for example KVM or VirtualBox.



1) Download the KVM qcow2 image:

https://cdn.amazonlinux.com/os-images/2.0.20200304.0/kvm/



2) Reset the VM root/ec2-user password by booting into grub menu press 'e' 

look at the line below that **ro** and change it with 
**rw init=/sysroot/bin/sh** look at the picture below.



3)  **Control + x** on your keyboard and give it some seconds to enter single mode.

then run

```
chroot /sysroot
passwd root
passwd ec2-user
touch /.autorelabel
exit
reboot 
```



4) Now you have bootable and user accessible AL2 vm locally installed, it is better to take snapshot of this fresh instance. An optional step is to edit 
'/etc/ssh/sshd_config' to allow PasswordAuthentication. 



5) Ensure the Ansible controller and target can ssh to each user using ssh keys. meaning the machine with ansible code should be able to 'ssh ec2-user@ansible_taget_ip'



6) You can test connectivity by target machines without invoking commands by:

```
ansible test -i inventory.qa -m ping
```



7)  Clone the repo :

```
git clone git@bitbucket.org:paramountcommercecom/ansible.git
cd ansible/roles/tomcat

```



8)  Edit the following files:

```
inventory.qa 
vars/main.yml.sample 
```



Ensure you have the correct hosts specified, and that ansible controller can reach the target using ssh key exchange, then run:

```
ansible-playbook -i inventory.qa -l kvm_test main.yml --extra-vars "@vars/main.yml"
ansible-playbook -i inventory.qa -l kvm_test main.yml --extra-vars "@vars/main.yml" --ask-vault-pass

```



Also be sure to edit/check the vars/main.yml first.



Resources:

https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/amazon-linux-2-virtual-machine.html

https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/amazon-linux-2-virtual-machine.html#amazon-linux-2-virtual-machine-download

https://medium.com/shehuawwal/download-and-run-amazon-linux-2-ami-locally-on-your-virtualbox-or-vmware-b554a98dcb1c