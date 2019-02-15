#!/bin/sh

#Script by PrivateHeberg - Feb 2019

#Colors
RED='\033[0;31m'
GREEN='\033[1;32m'
BLUE='\033[1;34m'
RESET='\033[0m'

#Check if user has root access
if [ $(id -u) != 0 ]; then
    clear
    echo "${RED}Merci de lancer le script avec les droits d'administrateur (root)${RESET}"
    exit
fi

ip=$(LANG=c ifconfig eth0 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}' | tee /dev/tty)

if [ -z $ip ]; then
    ip=$(LANG=c ifconfig venet0:0 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}' | tee /dev/tty)
fi

clear
echo "-----------------------------------------------"
echo "Installation automatique d’un serveur Apache2 et serveur MySQL de sous Debian"
echo "Par PrivateHeberg (privateheberg.com)"
echo "${GREEN}Lancement dans 5 secondes${RESET}"
echo "-----------------------------------------------"
sleep 5

clear
echo "Mise à jour des packets"
sleep 2
apt update

clear
echo "Installation d'Apache2"
sleep 2
apt install apache2

clear
echo "Installation de PHP"
sleep 2
apt-get install apt-transport-https lsb-release ca-certificates
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" >> /etc/apt/sources.list.d/php.list
apt-get update
apt-get install php7.2 php7.2-opcache libapache2-mod-php7.2 php7.2-mysql php7.2-curl php7.2-json php7.2-gd  php7.2-intl php7.2-mbstring php7.2-xml php7.2-zip php7.2-fpm php7.2-readline

clear
echo "Redémarrage d'Apache2"
sleep 2
service apache2 restart

rm /var/www/html/index.html
echo "<?php phpinfo();" >> /var/www/html/index.php

clear
echo "Installation du serveur MySQL et de phpMyAdmin"
sleep 2
apt-get install mysql-server
apt-get install phpmyadmin
ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin

clear
echo "Site web disponible à : http://$ip/"
echo "PhpMyAdmin disponible à : http://$ip/phpmyadmin"
echo "Chemin vers les fichiers de votre site : /var/www/html/"
