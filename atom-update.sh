#!/bin/bash

UB_OS=`uname -a | awk '{print $4}' | cut -d"-" -f2`
FED_OS=`uname -r | cut -d. -f4`

if [[ "$UB_OS" == "Ubuntu"  ]]; then
  PKG='atom.deb'
  CURRENT=`sudo apt --installed list 2> /dev/null| grep atom | grep -v libatomic | cut -d" " -f2`
  DOWNLOAD='deb'
  CMD='dpkg -i'
elif [[ "$FED_OS" =~ ^fc ]]; then
  PKG="atom.rpm"
  DOWNLOAD='rpm'
  if [[ "$FED_OS" =~ ^fc2[2-3] ]]; then
    CMD="dnf install -y"
    CURRENT=`sudo dnf list installed | grep ^atom | awk '{print $2}' | cut -f1 -d"-"`
  else
    CMD="yum localinstall -y"
    CURRENT=`sudo yum list installed | grep ^atom | awk '{print $2}' | cut -f1 -d"-"`
  fi
else
  echo "Unsupported Operating System"
  exit 1
fi


update_atom() {
    MASTER=`curl -s https://atom.io/releases | grep release-date | grep -v beta |awk '{print $1}' | head -1 | cut -d">" -f2 | tr -d 'v'`
    if [ "$MASTER" != "$CURRENT" ]; then
        echo "Downloading Update...."
        wget https://atom.io/download/$DOWNLOAD -O $PKG &> ./aupdater.log
        echo "Installing Update...."
        sudo $CMD $PKG &> ./aupdater.log
        echo "Cleanup...."
        rm -rf $PKG &> ./aupdater.log
        echo "Complete!"
    else
        echo "Atom is up to date"
    fi
}

update_packages() {
    apm update
}

update_all() {
    update_atom
    update_packages
}

case $1 in
    atom)
        update_atom
        ;;
    pkgs)
        update_packages
        ;;
    *)
        update_all
        ;;
esac
