#!/usr/bin/env ruby
#	
#	Install/bootstrap script for seteam_demobuild package.  Script will setup
#	Puppet environment on Mac, and kick off a Puppet run to complete rest of 
#	setup steps.

require "open-uri"

$puppet_url_prefix = "http://downloads.puppetlabs.com/mac/"
$puppet_pkgs = [ "facter-latest.dmg", 
								 "hiera-latest.dmg", 
								 "puppet-latest.dmg"
			   			 ]
$html_lines = `curl #{$puppet_url_prefix}`.split("\n")
$installed_pkgs = []		

def get_pkgs(pkgs)

	# Downloads relevant packages to install from Puppet Labs site
	# Params:
	# +pkgs+:: an array of packages to install

  pkgs.each do |pkg|	
    File.open(pkg, 'wb') do |fo|
      fo.write open($puppet_url_prefix + pkg).read
    end
  end
end

def get_inst_pkgs()

	# Get list of packages currently installed on system

	installed_pkgs = `pkgutil --packages | grep puppetlabs`.split("\n")

	installed_pkgs.each do |pkg|
		puts pkg
	end
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


# Main

has_puppet = false
has_facter = false
has_hiera = false

# Determine latest versions
latest_puppet = get_latest_ver('puppet')
latest_hiera = get_latest_ver('hiera')
latest_facter = get_latest_ver('facter')

if ENV['USER'] != 'root'
	puts "This script should be run as root.  Exiting."
	exit
end

if curr_puppet
	puts 'it worked'
end


