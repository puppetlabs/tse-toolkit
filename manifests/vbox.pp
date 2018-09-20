# Configure VirtualBox
# forked from github:boxen/puppet-virtualbox
# Usage:
#
#   include virtualbox
class toolkit::vbox (
  $version,
  $patch_level,
) {
  exec { 'Kill Virtual Box Processes':
    command     => 'pkill "VBoxXPCOMIPCD" || true && pkill "VBoxSVC" || true && pkill "VBoxHeadless" || true',
    path        => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    refreshonly => true,
  }

  package { "VirtualBox-${version}-${patch_level}":
    ensure   => present,
    provider => 'pkgdmg',
    source   => "http://download.virtualbox.org/virtualbox/${version}/VirtualBox-${version}-${patch_level}-OSX.dmg",
    require  => Exec['Kill Virtual Box Processes'],
  }

# exec { 'curl vbox extension':
#   command => "/usr/bin/curl http://download.virtualbox.org/virtualbox/${version}/Oracle_VM_VirtualBox_Extension_Pack-${version}-${patch_level}.vbox-extpack -o /tmp/Oracle_VM_VirtualBox_Extension_Pack-${version}-${patch_level}.vbox-extpack",
#  unless  => '/usr/local/bin/VBoxManage list extpacks | grep true',
# }

# exec { 'install vbox extension':
#  command => "/usr/local/bin/VBoxManage extpack install /tmp/Oracle_VM_VirtualBox_Extension_Pack-${version}-${patch_level}.vbox-extpack",
#  unless  => '/usr/local/bin/VBoxManage list extpacks | grep true',
# }
}
