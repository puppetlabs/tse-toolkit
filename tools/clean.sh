#!/bin/bash
# A very quick and dirty way of undoing work done by seteam_demostack bootstrap
# package.  Not very reliable nor production ready.  BE VERY CAREFUL RUNNING THIS.
#

# Variable initialization
verbose=0
user=""
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd ) # Get directory of where script is
OPTIND=1

while getopts "\?hu:" opt; do
  case "$opt" in
  h|\?)
      echo "You are beyond help."
      exit 0
      ;;
  u)  user=$OPTARG
      ;;
  v)  verbose=1
      ;;
  esac
done 

shift $((OPTIND-1))

# Very simple user error checking
if [ "$user" = '' ]; then
  echo "A username required... bailing."
  exit 1;
fi

if [ "$(whoami)" != 'root' ]; then
  echo "privileged account required"
  exit 1;
fi

echo 
echo "I am about to remove user account $user and its home directory."
echo -n "Are you sure you want to do this? (YES/no), then enter: "
read answer

if [ "$answer" != 'YES' ]; then
  echo "bailing..."
  exit 0;
fi

for f in $(pkgutil --only-files --files com.puppetlabs.puppet); do rm /$f; done
for d in $(pkgutil --only-dirs --files com.puppetlabs.puppet | tail -r); do rmdir /$d; done
pkgutil --forget com.puppetlabs.puppet
for f in $(pkgutil --only-files --files com.puppetlabs.hiera); do rm /$f; done
for d in $(pkgutil --only-dirs --files com.puppetlabs.hiera | tail -r); do rmdir /$d; done
pkgutil --forget com.puppetlabs.hiera
for f in $(pkgutil --only-files --files com.puppetlabs.facter); do rm /$f; done
for d in $(pkgutil --only-dirs --files com.puppetlabs.facter | tail -r); do rmdir /$d; done
pkgutil --forget com.puppetlabs.facter
for f in $(pkgutil --only-files --files com.puppetlabs.puppet-agent); do rm /$f; done
for d in $(pkgutil --only-dirs --files com.puppetlabs.puppet-agent | tail -r); do rmdir /$d; done
pkgutil --forget com.puppetlabs.puppet-agent

$DIR/vagrant-uninstall.tool
$DIR/vbox-uninstall.tool

dscl . -delete /Users/$user
rm -rf /Users/$user
