# Basic setup of user account and home directory
class tse_toolkit::env (
  $user,
) {

  $demostack_tarball = 'seteam-vagrant-latest.tar.gz'
  
  user { $user: 
    ensure      => 'present',
    groups      => ['_appserveradm', '_appserverusr', '_lpadmin', 'admin'],
    gid         => '20',
    shell       => '/bin/bash',
    home        => "/Users/${user}",
  }

  # Workaround since Puppet managehomedir for Mac doesn't work
  file { "/Users/${user}":
    ensure      => 'directory',
    owner       => $user,
    group       => 'staff',
    require     => User[$user],
  }

  file { [ "/Users/${user}/vagrant_tse_toolkit", "/Users/${user}/Downloads" ]:
    ensure  => 'directory',
    owner   => $user,
    group   => 'staff',
    require => File["/Users/${user}"],
  }

  exec { 'curl_demostack':
    command => "/usr/bin/su - ${user} -c '/usr/bin/curl https://s3-us-west-2.amazonaws.com/tse-builds/seteam-vagrant/${demostack_tarball}\
                -o /Users/${user}/Downloads/${demostack_tarball}'", 
    unless  => "/bin/test -f /Users/${user}/Downloads/${demostack_tarball}",
  }

}