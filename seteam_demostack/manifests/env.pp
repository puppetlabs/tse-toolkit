class seteam_demostack::env (
  $user = $seteam_demostack::params::user
) inherits seteam_demostack::params {

  # include wget

  $puppet_bins = [ 'facter', 'hiera', 'puppet' ]
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

  file { [ "/Users/${user}/vagrant_seteam_demostack", "/Users/${user}/Downloads" ]:
    ensure  => 'directory',
    owner   => $user,
    group   => 'staff',
    require => File["/Users/${user}"],
  }

  #wget::fetch { 'https://s3-us-west-2.amazonaws.com/tse-builds/seteam-vagrant/seteam-vagrant-latest.tar.gz':
  #  destination => '/Users/${user}/vagrant_seteam_demostack',
  #  cache_dir    => '/Users/${user}/Downloads',
  #}

  exec { 'curl_demostack':
    command => "/usr/bin/su - ${user} -c '/usr/bin/curl https://s3-us-west-2.amazonaws.com/tse-builds/seteam-vagrant/${demostack_tarball}\
                -o /Users/${user}/Downloads/${demostack_tarball}'", 
    unless  => "/bin/test -f /Users/${user}/Downloads/${demostack_tarball}",
  }

#  $puppet_bins.each |String $puppet_bin| {
#    file { "/usr/bin/${puppet_bin}": 
#      ensure => 'link',
#      target => "/opt/puppetlabs/puppet/bin/$puppet_bin",
#      owner  => 'root',
#      group  => 'wheel',
#      mode   => '0755',
#    }
#  }
}