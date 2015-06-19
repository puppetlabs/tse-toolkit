#!/usr/bin/env ruby
#	
#	Install/bootstrap script for seteam_demobuild package.  Script will setup
#	Puppet environment on Mac, and kick off a Puppet run to complete rest of 
#	the build.

require 'open-uri'
require 'optparse'

		

def get_pkg(pkg)
	# Downloads relevant package to install from Puppet Labs site
	# Params:
	# +pkgs+:: an array of packages to install

  File.open(pkg + "-latest.dmg", 'wb') do |fo|
    fo.write open($puppet_url_prefix + pkg + "-latest.dmg").read
  end
end

def pkginfo(pkgs)
	# Wrapper function that will gather all info on installed and available
	# packages to do later logic on what to install
	# Params:
	# +pkgs+:: Array of packages to install
	# Returns:
	# +pkgs_info+:: Array of hashes containing all package info

  pkgs_info = []
	pkgs.each do |pkg|
		pkgs_info.push({ "app" => pkg, 
			               "current" => get_instd_ver(pkg),
			               "latest" => get_latest_ver(pkg),
			             })
	end

  return pkgs_info
end


def get_instd_ver(pkg)
	# Get info of package currently installed on system (or if it isn't installed)
	# Params:
	# +pkg+:: Package to look up
	# Returns:
	# +version+:: Version of package installed, 0 if not installed

	instd_pkgs = `pkgutil --packages | grep puppetlabs`.split("\n")
	installed = false
	version = 0

	instd_pkgs.each do |package|
		if package.include? pkg 
			installed = true
		end
	end

	if installed
		begin
		  version = `#{pkg} --version`.chomp
		rescue
			puts "Looks like #{pkg} was uninstalled improperly... will try continuing."
		end
	end

	return version
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
	  my_match = /href\="#{pkg}\-(\d\.\d\.\d)\.dmg"/.match(line)
	  if my_match
	  	versions.push(my_match[1])
	  end
	end

  # This makes assumption that page maintainer is correctly ordering 
  # versions 
	latest = versions[-1]
	return latest
end

def install_pkgs(pkgs)
	# Install packages or update as necessary
  # Doing all removal before installation to avoid potential deletion clobeering issues between
  # packages
	pkgs.each do |pkg|
    if pkg["current"] != pkg["latest"] && pkg["current"] != 0 # not current
      puts "\nRemoving #{pkg["app"]} version #{pkg["current"]}."
      # HACK to clean up files from uninstall but retain configuration files.  
      # Should revisit after all in one client is released.
      system("for f in $(pkgutil --only-files --files com.puppetlabs.#{pkg["app"]}| 
             grep -v etc); do sudo rm /$f; done")
      system("for d in $(pkgutil --only-dirs --files com.puppetlabs.#{pkg["app"]} | 
             grep #{pkg["app"]} | grep -v etc | tail -r); do sudo rmdir /$d; done")
      system("pkgutil --forget com.puppetlabs.#{pkg["app"]}")
    end
  end
    
  pkgs.each do |pkg|
    if pkg["current"] == 0 || pkg["current"] != pkg["latest"] 
    	puts "\nInstalling #{pkg["app"]}..."
    	get_pkg(pkg["app"])
    	system("hdiutil mount #{pkg["app"]}-latest.dmg")

    	puts "installing #{pkg["app"]}"
    	system("installer -package /Volumes/#{pkg["app"]}-#{pkg["latest"]}/#{pkg["app"]}-#{pkg["latest"]}.pkg -target /")

    	puts "Cleaning up..."
    	system("umount /Volumes/#{pkg["app"]}-#{pkg["latest"]}")
      system("rm #{pkg["app"]}-latest.dmg")
    end
  end
end

def parse_options()
  # Use optparse to get options
  # Returns:
  # +options+:: Command line arguments
  #
  ARGV << '-h' if ARGV.empty? # autodisplay help banner if no options
  options = {}
  optparse = OptionParser.new do|opts|
    opts.banner = "\nUsage: autodemo.rb -u|--username username\n\n"
    options[:username] = ""
    
    opts.on('-u', '--username USERNAME', "username is mandatory.") do|u|
      options[:username] = u
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

  options = parse_options()

  puts "\n\nBootstrapping TSE environment..."
  puts "Configuring environment for user #{options[:username]}"
  puts "Getting Puppet package info on system..."

  # Install Puppet
  $puppet_url_prefix = "http://downloads.puppetlabs.com/mac/"
  $pkgs = [ "facter", "hiera", "puppet" ]
  $html_lines = `curl #{$puppet_url_prefix}`.split("\n")
  $installed_pkgs = []
  package_info = pkginfo($pkgs)
  puts "Checking current Puppet packages..."
  install_pkgs(package_info)

  # Copy Puppet code to right location



  #puts "\nInitiating Puppet run..."
  #system("puppet apply --modulepath='/Users/kai' tests/init.pp")
end


