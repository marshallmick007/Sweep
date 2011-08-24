#!/usr/bin/env ruby


require 'fileutils'
require 'yaml'

CONFIG_FILE = '.sweep.yaml'
DEFAULT_CONFIG='~/' + CONFIG_FILE

# Class to handle loading of a config file into
# a Sweeper object
class ConfigLoader
    
    # Creates a Sweeper class for the specified folder
    def create(folder)
        s = Sweeper.new(folder)
        s.mapping = load(s)
        
        s
    end

    # Loads the sweeper with the appropriate configuration
    def load(sweeper)
        f = sweeper.which_config
        cfg = default
        if File.exists?(f)
            cfg = YAML.load_file(f)
            if !cfg
                puts "Error loading config from #{f}"
                puts "Using default config"
                cfg = default
            end
        end

        cfg
    end

    # Returns the default sweep mappings
    def default
        {
            'music' => ['mp3', 'flac', 'mp4'],
            'docs' => ['pdf'],
            'zips' => ['zip', 'gz', 'bz2'],
            'apps' => ['dmg'],
            'images' => ['jpg','png','bmp'],
            'videos' => ['mov', 'avi', 'm4v']
        }
    end

    # Tests the mappings were loaded properly
    def testoutput(cfg)
        #puts default.class
        cfg.each do |key, value|
            puts key
            cfg[key].each do |ext|
                puts "\t#{ext}"
            end
        end
    end
end

# Class which inspects the target folder and sweeps files
# which match a mapping into the appropriate folder(s)
class Sweeper

    attr_accessor :folder
    attr_accessor :mapping
    attr_accessor :config

    def initialize(folder)
        @folder = folder
    end

    # Does a config file exist in the target directory?
    def local_config_exists?
        return File.exists? local_config_file
    end

    # Loads the config file from the target directory
    def local_config_file
         File.join(File.expand_path(@folder), CONFIG_FILE)
    end

    # Returns either the config file from the target directory
    # if it exists, or the default config file
    def which_config
        if local_config_exists?
            local_config_file
        else
            DEFAULT_CONFIG
        end
    end

    # Loads the config file category mappings
    def map_config
        m = Hash.new
        @mapping.each do |k,v|
            v.each do |ext|
                m[ext] = k
            end
        end

        m
    end

    # Move files in the target directory to the cleaned up
    # folders specified in the map_config
    def sweep
        m = map_config
        unmapped = []
        # For each file in the folder @folder
        Dir.foreach @folder do |file|
            FileUtils.cd @folder 

            # If we are indeed looking at a file and not a directory
            if File.file?(file)
                ext = File.extname(file).downcase
                ext.slice!(0)
                if m.key?(ext)
                    #Check to make sure that m.value folder exists
                    #if not, create it
                    target_dir = @folder + "/" + m[ext]
                    puts "Moving #{file} to #{target_dir}"

                    #Move the file into the folder
                    FileUtils.mkdir_p(target_dir) unless Dir.exists?(target_dir)
                    FileUtils.move(file, "#{target_dir}/#{file}")
                else
                    unmapped.push file
                end
            end
        end

        puts ""
        puts "Unable to clean up:"
        unmapped.each do |f|
            puts f
        end
    end
end

# Performs a test sweep against the target directory, 
# using the target config mappings. No files are moved
# during this process
class TestSweeper < Sweeper
    def sweep
        m = map_config
        m.each do |k,v|
            puts "#{k}: #{v}"
        end
        filemap = Hash.new
        unmapped = []
        Dir.foreach @folder do |file|
            FileUtils.cd @folder

            if File.file?(file)
                ext = File.extname(file).downcase
                ext.slice!(0)
                if filemap.key?(ext)
                    filemap[ext].push(file)
                elsif m.key?(ext)
                    filemap[ext] = [file]
                else
                    unmapped.push file
                end
            end
            #puts File.basename file
        end

        filemap.each do |ext, file|
            puts "#{ext}: #{file}"
        end

        puts ""
        puts "Unable to clean up:"
        unmapped.each do |f|
            puts f
        end
    end

end

if ARGV.empty?
    #display usage
    puts "Please supply a folder to sweep"
end

ARGV.each do |a|

    loader = ConfigLoader.new

    s = loader.create a

    s.sweep
end

