atom-linux-updater
================

A simple bash script to update the Atom text editor on Fedora and Ubuntu Linux distributions (and their derivatives). At least until Atom creates Repos for
the distributions.

Usage
-----

1. Clone this repository to your machine.
2. Make the script executable:
``` bash
chmod +x atom-update.sh
```
3. Run script

Options
-------

atom-update.sh defaults to updating Atom and the Atom Packages if no options are
used. Below are the supported options.

#### atom

Will update only the core Atom package

#### pkgs

Will check for updates to any install Atom Packages
