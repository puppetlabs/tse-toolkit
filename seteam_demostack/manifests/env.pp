class seteam_demostack::env (
  $user = $seteam_demostack::params::user
) inherits seteam_demostack::params {
  
  user { $user: 
    ensure      => 'present',
    groups      => ['_appserveradm', '_appserverusr', '_lpadmin', 'admin'],
    gid         => '20',
    shell       => '/bin/bash',
    home        => "/Users/${user}",
  }

  # Hack since Puppet managehomedir for Mac doesn't work
  file { "/Users/${user}":
    ensure      => 'directory',
    subscribe   => User[$user],
    owner       => $user,
    group       => 'staff',
  }
}