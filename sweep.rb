#!/usr/bin/env ruby

dir = File.dirname(__FILE__)
lib = File.expand_path(File.join(dir, 'lib'))

$LOAD_PATH << lib

require 'sweep'

if ARGV.empty?
  #display usage
  puts "Please supply a folder to sweep"
  exit
end

ARGV.each do |a|

  if File.directory? a 
    loader = Sweep::Config::ConfigLoader.new a

    sweeper = Sweep::Sweeper.new loader

    sweeper.sweep
  else
    puts "#{a} is not a directory"
  end

end

