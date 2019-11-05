alias mykey='cat ~/.ssh/id_rsa.pub'
alias upgrade='sudo apt-get update -y && sleep 5 && sudo apt-get upgrade -y && sleep 5 && sudo apt-get dist-upgrade -y && sudo snap refresh'
alias clean='sudo apt-get clean all -y && sudo apt-get autoclean -y && sleep 3 && sudo apt-get autoremove -y && sudo purge-old-kernels -y && sudo apt install -f'
alias c='clear'
alias lamp='sudo systemctl start apache2 && sudo systemctl start mysql'
alias lamps='sudo systemctl stop apache2 && sudo systemctl stop mysql'
alias pw='pwgen -s -1 32'
alias lampf='sudo chown -R www-data:www-data /var/www/html/'
alias htop='sudo htop'
alias dns='sudo systemd-resolve --flush-caches'
alias fsck='sudo touch /forcefsck'
alias bashrc='source ~/.bashrc'
alias myip='dig +short myip.opendns.com @resolver1.opendns.com'
alias updatedb='sudo updatedb'
alias swap='sudo swapoff -a && sudo swapon -a'
alias cleantmp='sudo find /tmp -type f -atime +1 -delete'
alias install='sudo apt-get install '
