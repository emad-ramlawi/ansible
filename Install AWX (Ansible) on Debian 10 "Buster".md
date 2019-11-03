## Install AWX (Ansible) on Debian 10 "Buster"
---

### install some basic software
apt install -y ansible docker docker-compose git python3-docker ansible-tower-cli

### start docker and enable autostart
systemctl enable docker
systemctl start docker

### change default version of python to version 3
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

### install awx
ansible-playbook install.yml -i inventory

---

*If no errors occurred here, you can enter the host name of the machine in the browser, log in with the user 
"admin" and the password "password" and get started.*

---

### launch awx on reboot
@reboot bash /root/start_awx.sh
cd /var/lib/awx && docker-compose start
chmod +x /root/start_awx.sh

### stop awx 
cd /var/lib/awx && docker-compose stop

### update awx
cd /var/lib/awx
docker-compose stop
docker-compose pull && docker-compose up --force-recreate -d

### source:
https://www.andrehotzler.de/en/blog/technology/81-install-awx-ansible-on-debian-10-buster.html
