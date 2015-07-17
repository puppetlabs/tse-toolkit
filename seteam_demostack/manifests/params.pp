class seteam_demostack::params {

  # demobuild.rb should populate this stuff
  $user = 'username'
  
  # Virtual Box stuff
  $vbox_version = '5.0.0'
  $vbox_patch_level = '101573'

  # Vagrant stuff
  $vagrant_version = '1.7.4' 
  $vagrant_plugins = [ 'oscar', 'vagrant-multiprovider-snap', 'vagrant-reload']

  $packages = [ "Vagrant_${vagrant_version}", 
                "VirtualBox-${vbox_version}-${vbox_patch_level}"]
}
