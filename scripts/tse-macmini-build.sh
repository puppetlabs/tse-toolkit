#!/bin/bash
# Script used to bring up environments for Mac minis as tseadmin
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/MacGPG2/bin
cd /Users/tseadmin
curl -sL http://git.io/tse-toolkit | sudo ruby 
cd /Users/tseadmin/vagrant_tse_demos/pe-demo*
sleep 2
chown tseadmin .vagrant
sudo -S -u tseadmin -i /bin/bash -l -c '/Users/tseadmin/vagrant_tse_demos/pe-demo*/scripts/init.sh >> /Users/tseadmin/vagrant_tse_demos/init.log'
vagrant puppetize | sudo /opt/puppetlabs/puppet/bin/puppet apply
