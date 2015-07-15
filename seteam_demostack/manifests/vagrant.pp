# Installs Vagrant and requisite Vagrant plugins for TSE environment
# forked from github:boxen/puppet-vagrant
#
# Usage:
#
#   include vagrant

class seteam_demostack::vagrant(
  $version = $seteam_demostack::params::vagrant_version,
  $plugins = $seteam_demostack::params::vagrant_plugins,
  $user = $seteam_demostack::params::user,
  $completion = false
) inherits seteam_demostack::params {

  # On OS X, Puppet leaves behind a file to 'know' it installed something, this cleans
  # it up. 
  exec { "clean-vagrant":
    command => "/bin/rm /var/db/.puppet_pkgdmg_installed_Vagrant*",
    onlyif  => [
                "/bin/test -f /var/db/.puppet_pkgdmg_installed_Vagrant*",
                "/bin/test ! -f /usr/bin/vagrant"
               ],
  }

  package { "Vagrant_${version}":
    ensure   => installed,
    source   => "https://dl.bintray.com/mitchellh/vagrant/vagrant_${version}.dmg",
    provider => 'pkgdmg',
  }

  file { "/Users/${user}/.vagrant.d":
    ensure  => directory,
    owner   => $user,
    group   => 'staff',
    require => Package["Vagrant_${version}"],
  }

  seteam_demostack::vagrant_plugin { $plugins:
    ensure => present,
    require  => Package[ "Vagrant_${version}"],
  }
}
