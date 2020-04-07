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
