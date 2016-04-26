define toolkit::vagrant_plugin(
  $user,
) {
    
  $plugin_name = $name

  exec { "vagrant_plugin_${name}":
    command => "/usr/bin/su - ${user} -c '/usr/local/bin/vagrant plugin install ${name}'",
    unless  => "/usr/bin/su - ${user} -c '/usr/local/bin/vagrant plugin list | grep ${name}'",
  }
}
