### Amazon Linux 2 Setup:



There are 2 parts of this process, Setup the repo "Controller" then Setup the local testing machine/client "Target".

Moving forwards we will reference  the machine that clones the repo and runs Ansible on clients as the "Controller".
and any the machine that Ansible executes on as the "Target". We will need to setup the target part first to get the IP of the target.



#### A) Setup the local testing machine/client "Target":

Download and run AL2 locally using your preferred hyper-visor, for example KVM (linux) or VirtualBox (windows).



1) Download the KVM qcow2 image:

https://cdn.amazonlinux.com/os-images/2.0.20200304.0/kvm/



2) Install KVM hypervisor and run a couple of checks, kvm-ok should output KVM acceleration can be used and the grep should show the # of cpu cores. 

````
sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virtinst virt-manager cpu-checker
kvm-ok
grep -Eoc '(vmx|svm)' /proc/cpuinfo
````

If you have issue with the last 2 commands, check your machine BIOS and ensure virtualisation technology is enabled.



3)  Locate new program installed called Virtual Machine Manager --> open it --> File --> New VM --> Import existing disk image --> Browse --> Browse Local --> Select the downloaded file

then in the same window choose the operation system as "Redhat Enterprise Linux 7" --> Keep pressing Forward and Accept the defaults till you reach Finish, and start the VM.



4) Reset the VM root/ec2-user password by booting into grub menu press 'e' 

look at the line below that **ro** and change it with 
**rw init=/sysroot/bin/sh** look at the picture below, then when done press "Control + x" on your keyboard and give it some seconds to enter single mode.

 



<img src="/home/medo/.config/Typora/typora-user-images/image-20200723124152066.png" alt="image-20200723124152066" style="zoom: 80%;" />



then run

```
chroot /sysroot
passwd root
touch /.autorelabel
exit
reboot 
```

Now you can reboot and access with root user, notice first boot will connect to the internet and create the ec2-user, so wait for a couple of mins then try to login by pressing enter, then run

```
passwd ec2-user
```



5) Last steps is to take note of the IP of the test target and add ensure the controller can access the  target using ssh by adding the controller SSH pub key to the target. Optionally

edit `etc/ssh/sshd_config` to allow "PasswordAuthentication"  and restart the sshd service, so you can go to the controller and run this and it work ask for password:

`ssh ec2-user@ansible_taget_ip`



6) It is highly recommended to take snapshot in this golden fresh target status. Shutdown the target and open Virtual Machine Manager and click the last icon on the right then the plus sign.



#### B) Setup the repo "Controller":



 Install ansible and clone the repo :

```
sudo apt install ansible
git clone git@bitbucket.org:paramountcommercecom/ansible.git
cd ansible
```



Edit the following files:

- inv/qa -->  add your targets IP.
- main.yml -> select the roles you wish to run by commenting out.
- vars/main.yml --> modify the vars to your desired output then encrypt it for better security. You will need to replace any entry labelled with "xxxxxxxx"

```
vim inv/qa 
vim main.yml
vim vars/main.yml
ansible-vault encrypt vars/main.yml
```



Ensure that you can reach the target without issues, you should receive a pong 

```
ansible test -i inv/qa -m ping
```



Run Ansible:

```
ansible-playbook -i inv/qa -l kvm_test main.yml --extra-vars "@vars/main.yml" --ask-vault-pass
```



---



### Debian and Ubuntu AWX Setup:



```
## Install AWX (Ansible) on Debian 10 "Buster"
---

### install some basic software
apt-get update -y && sleep 5 && sudo apt-get upgrade -y && sleep 5 && sudo apt-get dist-upgrade -y
apt install -y git python3-docker ansible-tower-cli gnupg2 nano htop nload mc

sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
    
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian buster stable"

### for ubuntu replace:
### curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
### add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"

apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose

### start docker and enable autostart
systemctl enable docker
systemctl start docker

### change default version of python to version 3
python -V
python3 -V
update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1
update-alternatives --install /usr/bin/python python /usr/bin/python3 2

### clone awx
cd ~
git clone https://github.com/ansible/awx
cd ~/awx/installer

### changes parameters
nano inventory

postgres_data_dir="/var/pgdocker"
docker_compose_dir="/var/lib/awx"
project_data_dir=/var/awx_projects

### Due to errors, we now use latest Ansible 2.9.2 from Ubuntu repo:
echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu bionic main" | tee -a /etc/apt/sources.list
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
apt update
apt install ansible -y
ansible --version

### install awx
ansible-playbook install.yml -i inventory

### ubuntu unable to load docker-compose error
sudo apt install python-pip
sudo apt install python3-pip
pip install --upgrade setuptools
pip install wheel
pip install docker-compose
```
---

*If no errors occurred here, you can enter the host name of the machine in the browser, log in with the user 
"admin" and the password "password" and get started.*

---
```
### launch awx on reboot
crontab -e
@reboot bash /root/start_awx.sh

nano /root/start_awx.sh
cd /var/lib/awx && docker-compose start
chmod +x /root/start_awx.sh

### stop awx 
nano /root/stop_awx.sh
cd /var/lib/awx && docker-compose stop
chmod +x /root/stop_awx.sh

### update awx
cd /var/lib/awx && docker-compose stop
# bump the version twice here --> /var/lib/awx/docker-compose.yml
docker-compose pull && docker-compose up --force-recreate -d

### change image port settings
cd /var/lib/awx && docker-compose stop
nano /var/lib/awx/docker-compose.yml
cd /var/lib/awx && docker-compose start

### source:
https://www.andrehotzler.de/en/blog/technology/81-install-awx-ansible-on-debian-10-buster.html
```

---

*Backup and Restore AWX*

---

```
tower-cli config
nano ~/.tower_cli.cfg

host: http://127.0.0.1:80
username: admin
password: XXXXXXXXXXX
verify_ssl: False

tower-cli receive --all > awx_backup.json
tower-cli send awx_backup.json

```



----



### Ansible Vault Cheat sheet

```
ansible-vault create mysecrets.yml
cat mysecrets.yml
ansible-vault view mysecrets.yml
ansible-vault edit mysecrets.yml
ansible-vault rekey mysecrets.yml

ansible-vault encrypt classified.txt
ansible-vault decrypt classified.txt

ansible-playbook deploy.yml --ask-vault-pass
ansible-playbook deploy.yml --vault-password-file vault_pass.txt
```

