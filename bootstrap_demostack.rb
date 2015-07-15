#!/usr/bin/env ruby
#	
#	Install/bootstrap script for seteam_demobuild package.  Script will setup
#	Puppet environment on Mac, and kick off a Puppet run to complete rest of 
#	the build.
#
# Version works for all in one package
# DONE: Read website, download package
# TO DO: All in one install

require 'open-uri'
require 'optparse'
require 'fileutils'

def config_puppet(username)
  # Ensure basic directory structure.  Set up parameters and move Puppet module into place
  # Populates user parameter
  # Params:
  # +username+:: update username parameter to right user

  if !File.directory?($puppet_modulepath)
    FileUtils.mkdir_p($puppet_modulepath)
  end

  FileUtils.cp_r($module_name, $puppet_modulepath)
  
  FileUtils.chown_R("puppet", "puppet", $module_path)

  params_file = "#{$module_path}/manifests/params.pp"
  params_text = File.read(params_file)
  params_update = params_text.gsub(/\$user\ \=\ .*/, "$user = '#{username}'")
  File.open(params_file, "w") {|file| file.puts params_update}

end

def get_pc1(pkg_name_prefix)
	# Downloads PC1 package to install from Puppet Labs site
	# Params:
	# +pkg_name_prefix+:: Name prefix of package to download

  File.open(pkg_name_prefix + ".dmg", 'wb') do |fo|
    fo.write open($puppet_url_prefix + pkg_name_prefix + ".dmg").read
  end
end

def pkginfo(pkg)
	# Gather all info on installed and available
	# packages to do later logic on what to install
	# Params:
	# +pkgs+:: Array of packages to install
	# Returns:
	# +pkgs_info+:: Array of hashes containing all package info

	pkg_hash = { "app"       => pkg, 
               "installed" => is_installed(pkg),
			         "latest"    => get_latest_ver(pkg),
			       }
end

def get_latest_ver(pkg)
	# Determine latest published Puppet dmgs from website
	# Params:
	# +pkg+:: Package to lookup
	# Returns:
	# +latest+:: Latest version of a package

	versions = []
	latest = ''

	$html_lines.each do |line|
		# Match the version number on the puppet html and pull that out.
	  my_match = /href\="#{pkg}\-(\d\.\d\.\d)\-.*"/.match(line)
	  if my_match
	  	versions.push(my_match[1])
	  end
	end

  # This makes assumption that page maintainer is correctly ordering 
  # versions 
	latest = versions[-1]
	return latest
end

def is_installed(pkg)
  # Find out if package is installed
  # Params:
  # +pkg+:: Package lookup
  # Returns:
  # +boolean+:: If installed or not
  system("pkgutil --packages| grep '^com.puppetlabs.#{pkg}$'")
end

def install_pc1(pkg_name_prefix)
	# Install Puppet all-in-one package.
  # Params:
  # +pkg_name_prefix+:: 

  puts "\nInstalling #{pkg_name_prefix}..."
 	system("hdiutil mount #{pkg_name_prefix}.dmg")

 	system("installer -package /Volumes/#{pkg_name_prefix}/*installer.pkg -target /")

 	puts "Cleaning up..."
 	system("umount /Volumes/#{pkg_name_prefix}")
  system("rm #{pkg_name_prefix}.dmg")
  puts "\n"
end

def uninstall_pkg(pkg_hash)
  # Forcibly remove a package from system.  Very hackish. 

  # Skip this if not installed
  return unless pkg_hash["installed"]

  # Remove Puppet package from system.  Very hackish
  puts "Removing #{pkg_hash["app"]}."
  # HACK to clean up files from uninstall but retain configuration files.  
  # Should revisit after all in one client is released.
  system("for f in $(pkgutil --only-files --files com.puppetlabs.#{pkg_hash["app"]}| 
         grep -v etc); do sudo rm /$f; done")
  system("for d in $(pkgutil --only-dirs --files com.puppetlabs.#{pkg_hash["app"]} | 
         grep #{pkg_hash["app"]} | grep -v etc | tail -r); do sudo rmdir /$d; done")
  system("pkgutil --forget com.puppetlabs.#{pkg_hash["app"]}")
  puts "\n"

end

def parse_options()
  # Use optparse to get options
  # Returns:
  # +options+:: Command line arguments
  #
  ARGV << '-h' if ARGV.empty? # autodisplay help banner if no options
  options = {}
  options[:update] = false
  optparse = OptionParser.new do|opts|


    opts.banner = "\nUsage: autodemo.rb -u|--username username\n\n"
    options[:username] = ""
    
    opts.on('-u', '--username USERNAME', "username is mandatory.") do|u|
      options[:username] = u
    end

    opts.on('--update', "force update to latest versions of Puppet.") do
      options[:update] = true
    end

    opts.on_tail('-h', '--help') do
      puts opts.banner
      puts opts
      exit
    end
  end.parse!

  return options
end

# MAIN
if __FILE__ == $0
  # Bootstrap script and getopts
  if ENV['USER'] != 'root'
    puts "\nThis script should be run as root.  Exiting...\n\n"
    exit
  end

  $puppet_modulepath = "/opt/puppetlabs/puppet/modules"
  $module_name = "seteam_demostack"
  $module_path = "#{$puppet_modulepath}/#{$module_name}"
  $puppet_url_prefix = "http://downloads.puppetlabs.com/mac/PC1/"
  # This should be deprecated in subsequen version as PC1 becomes standard
  $pkgs = [ "facter", "hiera", "puppet", "puppet-agent" ]
  $html_lines = `curl --silent #{$puppet_url_prefix}`.split("\n")
  $installed_pkgs = []
  $osx_ver = /(^\d+\.\d+)/.match(`sw_vers -productVersion`).to_s
  package_info = [] 
  options = parse_options()

  puts "\n\nBootstrapping Puppet Demo environment..."
  puts "Configuring environment for user #{options[:username]}"
  puts "Getting Puppet package info on system..."

  $pkgs.each do |pkg|
    package_info.push(pkginfo(pkg))
  end

  puts package_info

  puts "Installing/Updating Puppet packages..."
  # Remove previous versions if requested
  if options[:update]
    package_info.each do |pkg|
      uninstall_pkg(pkg)
    end
  end

  # Install Puppet agent if requested or not currently installed
  # Format is: appname- + version- + osx- + osx version- + arch + .dmg
  pkg_name_prefix =  "puppet-agent-" + package_info[3]["latest"] + "-osx-" + $osx_ver + "-x86_64"
  get_pc1(pkg_name_prefix) if !package_info[3]["installed"] || options[:update]
  install_pc1(pkg_name_prefix) if !package_info[3]["installed"] || options[:update]

  # Set up Puppet directories and put manifests in place
  puts "\nSetting up Puppet environment..."
  config_puppet(options[:username])

  puts "\nInitiating Puppet run..."
  system("/opt/puppetlabs/puppet/bin/puppet apply -e 'include #{$module_name}' --trace")
end