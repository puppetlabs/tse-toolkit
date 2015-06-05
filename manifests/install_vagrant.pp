# Installs Vagrant and requisite Vagrant plugins for TSE environment
# forked from github:boxen/puppet-vagrant
#
# Usage:
#
#   include vagrant

class seteam_demobuild::install_vagrant(
  $version = $seteam_demobuild::params::vagrant_version,
  $plugins = $seteam_demobuild::params::vagrant_plugins,
  $user = $seteam_demobuild::params::user,
  $completion = false
) inherits seteam_demobuild::params {

  # On OS X, Puppet leaves behind a file to 'know' it installed something, this cleans
  # it up. 
  exec { "clean-vagrant}":
    command => "/bin/rm /var/db/.puppet_pkgdmg_installed_vagrant_${version}",
    onlyif  => [
                "/bin/test -f /var/db/.puppet_pkgdmg_installed_vagrant_${version}",
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
    require => Package["Vagrant_${version}"],
  }

  seteam_demobuild::vagrant_plugin { $plugins:
    ensure => present,
    require  => Package[ "Vagrant_${version}"],
  }
}
