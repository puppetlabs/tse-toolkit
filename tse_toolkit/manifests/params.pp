class tse_toolkit::params {

  $user           = 'username'
  $pe_version     = '2015.2.x'
  $pe_demo_url    = "http://tse-builds.s3-us-west-2.amazonaws.com/${pe_version}/commits/pe-demo-latest.tar.gz"
  
  $vbox_version     = '5.0.4'
  $vbox_patch_level = '102546'

  $vagrant_version = '1.7.4' 
  $vagrant_plugins = [ 'oscar', 'vagrant-hosts', 'vagrant-multiprovider-snap', 'vagrant-reload']

  $packages = [ "Vagrant_${vagrant_version}", 
                "VirtualBox-${vbox_version}-${vbox_patch_level}"]
}
