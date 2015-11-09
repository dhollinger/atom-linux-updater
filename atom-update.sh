#!/bin/bash

OS=`uname -r | cut -d. -f4`
if [[ "$OS" =~ ^fc2[2-3] ]]; then
    CMD="dnf"
else
    CMD="yum"
fi

update_atom() {
    PKG='atom.rpm'
    CURRENT=`sudo $CMD list installed | grep ^atom | awk '{print $2}' | cut -f1 -d"-"`
    MASTER=`curl -s https://atom.io/releases | grep release-date | grep -v beta |awk '{print $1}' | head -1 | tr -d '<h2>' | tr -d 'v'`

    if [ "$MASTER" != "$CURRENT" ]; then
        echo "Downloading Update...."
        wget https://atom.io/download/rpm -O $PKG &> ./aupdater.log
        echo "Installing Update...."
        sudo $CMD install -y $PKG &> ./aupdater.log
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
    pkg)
        update_packages
        ;;
    *)
        update_all
        ;;
esac
