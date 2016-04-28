#!/usr/bin/env ruby
#
# Fix for regex bug in Vagrant 1.8.1 Documented here:
# https://github.com/taurus-forever/vagrant/commit/f0d602a019fd494dcaa22a74ac4021da49d6db2e

file_name = '/opt/vagrant/embedded/gems/gems/vagrant-1.8.1/plugins/commands/up/command.rb'
version   = `/usr/local/bin/vagrant --version`.chomp

if ENV['USER'] != 'root'
  puts "\nTHIS SCRIPT SHOULD BE RUN AS root OR VIA sudo.  Exiting...\n"
  puts "\n\n"
  exit
end

if version != 'Vagrant 1.8.1'
  puts "\nScript does not apply to this version of Vagrant.  Exiting...\n"
  puts "\n\n"
  exit
end

text = File.read(file_name)
line = IO.readlines(file_name)[148].chomp

if line.include? "&& entry"
  puts "\nYour Vagrant install already appears to be fixed. Exiting...\n"
  puts "\n\n"
  exit
end

fix = text.gsub(line, line + " && entry")
File.open(file_name, "w") {|file| file.puts fix }

puts "\nI've patched up #{file_name}  Exiting...\n"
puts "\n\n"
