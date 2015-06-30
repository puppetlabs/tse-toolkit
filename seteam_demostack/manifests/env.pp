class seteam_demostack::env (
  $user = $seteam_demostack::params::user
) inherits seteam_demostack::params {
  user { $user: 
    ensure => 'present',
    groups => ['_appserveradm', '_appserverusr', '_lpadmin', 'admin'],
    gid => '20',
    shell => '/bin/bash',

    # managehome => 'true',
  }
}