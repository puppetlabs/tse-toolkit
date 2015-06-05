#!/usr/bin/env ruby
=begin
	
	Install/bootstrap script for seteam_demobuild package.  Script will setup
	Puppet environment on Mac, and kick off a Puppet run to complete rest of 
	setup steps.

=end

require "open-uri"

$puppet_url_prefix = "http://downloads.puppetlabs.com/mac/"
$puppet_pkgs = [
				"facter-latest.dmg", 
				"hiera-latest.dmg", 
				"puppet-latest.dmg"
			   ]

def get_pkgs
	$puppet_pkgs.each do |pkg|	
		File.open(pkg, 'wb') do |fo|
			fo.write open($puppet_url_prefix + pkg).read
		end
	end
end

get_pkgs


