# Installs Vagrant and requisite Vagrant plugins for TSE environment
# forked from github:boxen/puppet-vagrant
#
# Usage:
#
#   include vagrant

class seteam-autodemo::install-vagrant(
  $version = '1.7.2',
  $completion = false
) {

  package { "Vagrant_${version}":
    ensure   => installed,
    source   => "https://dl.bintray.com/mitchellh/vagrant/vagrant_${version}.dmg",
    provider => 'pkgdmg',
  }

  file { "/Users/${::boxen_user}/.vagrant.d":
    ensure  => directory,
    require => Package["Vagrant_${version}"],
  }

  seteam-autodemo::vagrant-plugin { 'vagrant-reload':
    ensure => present,
    require  => Package[ "Vagrant_${version}"],
  }
}
