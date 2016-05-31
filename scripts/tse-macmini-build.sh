#!/bin/bash
# Script used to bring up environments for Mac minis
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/MacGPG2/bin
export LANG=en_US.UTF-8
cd ~
curl -sL http://git.io/tse-toolkit | sudo ruby /dev/stdin -c
sudo /etc/puppetlabs/code/nimbus_environments/nimbus/modules/toolkit/scripts/vagrant_1.8.1_patch.rb
cd ~/vagrant_tse_demos/pe-demo*
~/vagrant_tse_demos/pe-demo*/scripts/init.sh >> ~/vagrant_tse_demos/init.log
vagrant puppetize | sudo /opt/puppetlabs/puppet/bin/puppet apply
