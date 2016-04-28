#!/usr/bin/env ruby
#
#	Install and bootstrap script for toolkit.  Script will setup
#	install latest puppet-agent on Mac, install tse/nimbus, and run a
# a configuration to bootstrap rest of environment.
#
require 'open-uri'
require 'optparse'
require 'fileutils'
$pkgs            = ['facter', 'hiera', 'puppet', 'puppet-agent']
$osx_ver         = /(^\d+\.\d+)/.match(`sw_vers -productVersion`).to_s
$pc1_ver         = /(\d+\.\d+.\d+)/.match(`pkgutil --pkg-info com.puppetlabs.puppet-agent`).to_s
$pc1_url         = 'http://downloads.puppetlabs.com/mac/' + $osx_ver + '/PC1/x86_64/'
$pc1_url_lines   = `curl --silent #{$pc1_url}`.split("\n")
$nimbus_conf_url = 'https://raw.githubusercontent.com/puppetlabs/tse-toolkit/master/nimbus-base.conf'
$package_info    = []

def config_nimbus(username)
  # Pull down default nimbus config from tse-toolkit repo and modify with user
  # Params:
  # +username+:: user account name that will be placed in nimbus-username.conf
  # Returns:
  # +nimbus_conf+:: nimbus config file path.
  nimbus_conf   = "/Users/#{username}/nimbus-#{username}.conf"
  system("curl #{$nimbus_conf_url} -o #{nimbus_conf}")
  system("chown #{username} #{nimbus_conf}")
  nimbus_text   = File.read(nimbus_conf)
  nimbus_update = nimbus_text.gsub(/user_account/, username)
  File.open(nimbus_conf, 'w') { |file| file.puts nimbus_update }
  return nimbus_conf
end

def get_pc1(pkg_name_prefix)
  # Downloads PC1 package to install from Puppet Labs site
  # Params:
  # +pkg_name_prefix+:: Name prefix of package to download
  File.open(pkg_name_prefix + '.dmg', 'wb') do |fo|
    fo.write open($pc1_url + pkg_name_prefix + '.dmg').read
  end
end

def pkginfo(pkg)
  # Gather all info on packages
  # Params:
  # +pkgs+:: Array of packages to install
  # Returns:
  # +pkgs_info+:: Array of hashes containing all package info
  pkg_hash = {
               'app'       => pkg,
               'installed' => installed?(pkg),
			         'latest'    => get_latest_ver(pkg),
             }
end

def get_latest_ver(pkg)
  # Determine latest published Puppet dmgs from website
  # Params:
  # +pkg+:: Package to lookup
  # Returns:
  # +latest+:: Latest version of a package
  versions = []
  $pc1_url_lines.each do |line|
		# Match the version number on the puppet html and pull that out.
	  my_match = /href\="#{pkg}\-(\d\.\d\.\d)\-.*"/.match(line)
    if my_match
      versions.push(my_match[1])
    end
  end

  latest = versions[-1]
end

def installed?(pkg)
  # Find out if package is installed
  # Params:
  # +pkg+:: Package lookup
  # Returns:
  # +boolean+:: If installed or not
  system("pkgutil --packages| grep '^com.puppetlabs.#{pkg}$' 1>/dev/null")
end

def install_pc1(pkg_name_prefix)
  # Install Puppet all-in-one package.
  # Params:
  # +pkg_name_prefix+::
  puts "\nInstalling #{pkg_name_prefix}..."
  system("hdiutil mount #{pkg_name_prefix}.dmg")
  system("installer -package /Volumes/#{pkg_name_prefix}/*installer.pkg -target /")
  puts 'Cleaning up...'
  system("umount /Volumes/#{pkg_name_prefix}")
  system("rm #{pkg_name_prefix}.dmg")
  puts "\n"
end

def uninstall_pkg(pkg_hash)
  # Forcibly remove a package from system.
  return unless pkg_hash['installed']
  puts "Removing #{pkg_hash['app']}."
  # HACK: to clean up files from uninstall but retain configuration files.
  # Should revisit after all in one client is released.
  if pkg_hash['app'] != 'puppet-agent' # For old agents since this left files everywhere
    system("for f in $(pkgutil --only-files --files com.puppetlabs.#{pkg_hash['app']}|
           grep -v etc); do sudo rm /$f; done")
    system("for d in $(pkgutil --only-dirs --files com.puppetlabs.#{pkg_hash['app']} |
           grep #{pkg_hash['app']} | grep -v etc | tail -r); do sudo rmdir /$d; done")
  else # Should be all-in-one agent and cleaner to remove
    system('rm -rf /opt/puppetlabs')
    system('rm /usr/bin/facter') if File.exist?('/usr/bin/facter')
    system('rm /usr/bin/hiera') if File.exist?('/usr/bin/hiera')
    system('rm /usr/bin/puppet') if File.exist?('/usr/bin/puppet')
  end
  system("pkgutil --forget com.puppetlabs.#{pkg_hash['app']}")
  puts "\n"
end

def parse_options
  # Use optparse to get options
  # +options+:: Command line arguments
  options            = {}
  options[:username] = `logname`.chomp # default to user login name
  OptionParser.new do|opts|
    opts.banner = "\nUsage: sudo ./install.rb\n
                   Note: default behavior is to install all-in-one agent if it isn't already
                   installed.  Also will leave older agent installs alone.  If you want to
                   update ONLY all-in-one agent, please choose '--update'.\n\n"

    opts.on('-u', '--username USERNAME', 'username defaults to currently logged in user.') do|u|
      options[:username] = u
    end

    opts.on_tail('-h', '--help') do
      puts opts
      puts "\n\n"
      exit
    end

    if ENV['USER'] != 'root'
      puts "\nTHIS SCRIPT SHOULD BE RUN AS root OR VIA sudo.  Exiting...\n"
      puts opts
      puts "\n\n"
      exit
    end
  end.parse!

  options
end

if __FILE__ == $PROGRAM_NAME
  options = parse_options
  puts "\n\nBootstrapping Puppet Demo environment..."
  puts "Configuring environment for user #{options[:username]}"
  puts 'Getting Puppet package info...'

  $pkgs.each do |pkg|
    $package_info.push(pkginfo(pkg))
  end

  # Either AIO is not installed or installed version isn't latest on website
  if !$package_info[3]['installed'] || $package_info[3]['latest'] != $pc1_ver
    puts 'Removing all previous versions of Puppet agent...'
    $package_info.each do |pkg|
      uninstall_pkg(pkg)
    end
    puts 'Installing latest Puppet all-in-one agent...'
    pkg_name_prefix = 'puppet-agent-' + $package_info[3]['latest'] + '-1.osx' + $osx_ver
    get_pc1(pkg_name_prefix)
    install_pc1(pkg_name_prefix)
  end

  puts 'Installing and configuring tse/nimbus...'
  system("/opt/puppetlabs/puppet/bin/puppet module install tse/nimbus")
  nimbus_conf = config_nimbus(options[:username])

  puts "\nRunning Puppet via Nimbus to set up environment..."
  system("/opt/puppetlabs/puppet/bin/puppet nimbus apply #{nimbus_conf}")
  puts "\nI've dropped your nimbus config file at #{nimbus_conf}  You can"\
       "\nreapply this configuration by running:\n"\
       "\nsudo /opt/puppetlabs/puppet/bin/puppet nimbus apply #{nimbus_conf}\n"\
       "\nOr modify this file to further customize your system."\
       "\nPlease review documentation at https://forge.puppet.com/tse/nimbus\n\n"
end
