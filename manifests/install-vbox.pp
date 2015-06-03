# Installs VirtualBox
# forked from github:boxen/puppet-virtualbox
# Usage:
#   
#   include virtualbox
class seteam-autodemo::install-vbox (
  $version = '4.3.28',
  $patch_level = '100309'
) {
  # Install Virtual Box
  exec { 'Kill Virtual Box Processes':
    command     => 'pkill "VBoxXPCOMIPCD" || true && pkill "VBoxSVC" || true && pkill "VBoxHeadless" || true',
    path        => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    refreshonly => true,
  }

  # On OS X, Puppet leaves behind a file to 'know' it installed something, this cleans
  # it up. 
  exec { 'clean-vbox-install':
    command => "/bin/rm /var/db/.puppet_pkgdmg_installed_VirtualBox-${version}-${patch_level}",
    onlyif  => [
                "/bin/test -f /var/db/.puppet_pkgdmg_installed_VirtualBox-${version}-${patch_level}",
                "/bin/test ! -d /Applications/VirtualBox.app/"
               ],
  }
    
  package { "VirtualBox-${version}-${patch_level}":
    ensure   => present,
    provider => 'pkgdmg',
    source   => "http://download.virtualbox.org/virtualbox/${version}/VirtualBox-${version}-${patch_level}-OSX.dmg",
    require  => Exec['Kill Virtual Box Processes'],
  }

}
