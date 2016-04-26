# Basic setup of user account and home directory
class toolkit::env (
  $user,
  $pe_demo_url
) {

  $demostack_tarball = 'pe-demo-latest.tar.gz'
  $demostack_path    = "/Users/${user}/vagrant_tse_demos"
  $downloads_path    = "/Users/${user}/Downloads"

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

  file { [ "${demostack_path}", "/Users/${user}/Downloads" ]:
    ensure  => 'directory',
    owner   => $user,
    group   => 'staff',
    require => File["/Users/${user}"],
  }

  exec { 'clean': 
    command => "/bin/rm ${downloads_path}/${demostack_tarball}",
    onlyif  => "/bin/test -f ${downloads_path}/${demostack_tarball}",
    before  => Exec['curl_demostack'],
  }

  exec { 'curl_demostack':
    command => "/usr/bin/su - ${user} -c '/usr/bin/curl ${pe_demo_url}\
                -o ${downloads_path}/${demostack_tarball}'", 
    before  => Exec['extract_tarball']
    #unless  => "/bin/test -f /Users/${user}/vagrant_tse_demo_envs/${demostack_tarball}",
  }

  exec { 'extract_tarball':
    command => "/usr/bin/su - ${user} -c '/usr/bin/tar xzf ${downloads_path}/${demostack_tarball}\
               -C ${demostack_path}'",
  }

}