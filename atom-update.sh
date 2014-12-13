#!/bin/bash

PKG='atom.rpm'
CURRENT=`yum list installed | grep ^atom | awk '{print $2}' | cut -f1 -d"-"`
MASTER=`curl -s https://atom.io/releases | grep release-date | awk '{print $1}' | head -1 | tr -d '<h2>' | tr -d 'v'`

if [ "$MASTER" != "$CURRENT" ]; then
  echo "Downloading Update...."
  wget https://atom.io/download/rpm -O $PKG 2>&1 /var/log/aupdater.log
  echo "Installing Update...."
  yum localinstall -y $PKG 2>&1 /var/log/aupdater.log
  echo "Cleanup...."
  rm -rf $PKG 2>&1 /var/log/aupdater.log
  echo "Complete!"
else
  echo "Atom is up to date"
fi
