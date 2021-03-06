# Installs Vagrant and requisite Vagrant plugins for TSE environment
# forked from github:boxen/puppet-vagrant
#
# Usage:
#
#   include vagrant

class toolkit::vagrant(
  $version,
  $plugins,
  $user,
) {
  package { "Vagrant_${version}":
    ensure   => installed,
    source   => "https://releases.hashicorp.com/vagrant/${version}/vagrant_${version}.dmg",
    provider => 'pkgdmg',
  }

  file { "/Users/${user}/.vagrant.d":
    ensure  => directory,
    owner   => $user,
    group   => 'staff',
    require => Package["Vagrant_${version}"],
  }

  toolkit::vagrant_plugin { $plugins:
    require  => File["/Users/${user}/.vagrant.d"],
    user     => $user,
  }
}
