#!/bin/bash

OS=`uname -r | cut -d. -f4`
if [[ "$OS" =~ ^fc2[2-3] ]]; then
    CMD="dnf"
else
    CMD="yum"
fi

PKG='atom.rpm'
CURRENT=`$CMD list installed | grep ^atom | awk '{print $2}' | cut -f1 -d"-"`
MASTER=`curl -s https://atom.io/releases | grep release-date | awk '{print $1}' | head -1 | tr -d '<h2>' | tr -d 'v'`

if [ "$MASTER" != "$CURRENT" ]; then
  echo "Downloading Update...."
  wget https://atom.io/download/rpm -O $PKG &> /var/log/aupdater.log
  echo "Installing Update...."
  $CMD localinstall -y $PKG &> /var/log/aupdater.log
  echo "Cleanup...."
  rm -rf $PKG &> /var/log/aupdater.log
  echo "Complete!"
else
  echo "Atom is up to date"
fi
