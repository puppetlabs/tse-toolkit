# Installs Vagrant and requisite Vagrant plugins for TSE environment
# forked from github:boxen/puppet-vagrant
#
# Usage:
#
#   include vagrant

class tse_toolkit::vagrant(
  $version,
  $plugins,
  $user,
) {
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

  tse_toolkit::vagrant_plugin { $plugins:
    require  => File["/Users/${user}/.vagrant.d"],
    user     => $user,
  }
}
