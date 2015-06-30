class seteam_demostack::params {

  # demobuild.rb should populate this stuff
  $user = 'username'
  
  # Virtual Box stuff
  $vbox_version = '4.3.28'
  $vbox_patch_level = '100309'

  # Vagrant stuff
  $vagrant_version = '1.7.2' 
  $vagrant_plugins = [ 'oscar', 'vagrant-multiprovider-snap', 'vagrant-reload']

  $packages = [ "Vagrant_${vagrant_version}", 
                "VirtualBox-${vbox_version}-${vbox_patch_level}"]
}
