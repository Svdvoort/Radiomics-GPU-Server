#!/bin/bash

#First install some required packages
apt-get install git

# Put ubuntu on a diet
apt-get --purge -y remove ubuntu-web-launchers thunderbird libreoffice* gbrainy rhythmbox

# Remove games
apt-get --purge -y remove aisleriot gnome-sudoku mahjongg ace-of-penguins gnomine gbrainy gnome-mahjongg gnome-mines
apt-get remove --purge -y shotwell cheese remmina simple-scan totem


# Make folder for all our installation stuff, we will use admin
mkdir -p /home/admin
cp -R ../../Radiomics-GPU-Server /home/admin

mkdir -p /packages

# Create group to add users to
groupadd researchers
