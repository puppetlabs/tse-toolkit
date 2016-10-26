#!/bin/bash
# Script used to bring up environments for Mac minis
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/MacGPG2/bin
cd ~
curl -sL http://git.io/tse-toolkit | sudo ruby 
cd ~/vagrant_tse_demos/pe-demo*
~/vagrant_tse_demos/pe-demo*/scripts/init.sh >> ~/vagrant_tse_demos/init.log
vagrant puppetize | sudo /opt/puppetlabs/puppet/bin/puppet apply
