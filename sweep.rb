#!/usr/bin/env ruby

dir = File.dirname(__FILE__)
lib = File.expand_path(File.join(dir, 'lib'))

$LOAD_PATH << lib

require 'sweep'

if ARGV.empty?
  #display usage
  #puts "Please supply a folder to sweep"
  puts "Usage: sweep.rb [OPTIONS] [DIRECTORIES]"
  puts "OPTIONS:"
  puts "        --force   Force the file move"
  exit
end

dirs = []
mode=:test

ARGV.each do |a|
  if a == "--force"
    mode = :force
  elsif a == "--prompt"
    mode = :prompt
  elsif File.directory? a
    dirs << a
  end
end

dirs.each do |folder|
  loader = Sweep::Config::ConfigLoader.new folder
  sweeper = Sweep::Sweeper.new loader
  sweeper.sweep mode
end

