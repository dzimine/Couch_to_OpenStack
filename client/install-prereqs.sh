# Pre-requirements for Debian/Ubuntu
# Tested on Ubuntu 12.04

# Node JS and NPM
sudo apt-get -y update
sudo apt-get -y install python-software-properties python g++ make
sudo add-apt-repository -y ppa:chris-lea/node.js
sudo apt-get update
sudo apt-get -y install nodejs
# Check
node --version
# v0.10.18
npm --version 
# 1.3.8


# Java
sudo apt-get install openjdk-7-jre

##  Note(DZ): oracle java install was reporing failing on ubuntu
## 
# sudo apt-get install -y python-software-properties python g++ make
# 
# sudo add-apt-repository -y ppa:webupd8team/java
# sudo apt-get update
# # state that you accepted the license 
# echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
# echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
# sudo apt-get install -y oracle-java7-installer
# # Check
java -version
#> java version "1.7.0_40"

### Install libvirt, libxml mysql client, curl, python, git
sudo apt-get install -y libvirt-bin python-libvirt
sudo apt-get install -y libxml2-dev libxslt1-dev
sudo apt-get install -y libmysqlclient-dev
sudo apt-get install -y curl
sudo apt-get install -y python-dev python-pip python-virtualenv
sudo apt-get install -y git

### Install apache and mod-wsgi
sudo apt-get install -y apache2 libapache2-mod-wsgi

# Screen 
# FIXME: This is temporary, while developing (will daemonize the processes later).
sudo apt-get install screen
which screen


  