require 'fileutils'
require 'yaml'

module Sweep
  module Config
    CONFIG_FILE = '.sweep.yaml'
    DEFAULT_CONFIG='~/' + CONFIG_FILE

    # Class to handle loading of a config file into
    # a Sweeper object
    class ConfigLoader
      attr_reader :folder
      attr_reader :config

      # Creates a ConfigLoader class for the specified folder
      def initialize(folder=nil)
        unless folder == nil 
          @config = load folder
        end
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


      # Loads the sweeper with the appropriate configuration
      def load(folder)
        @folder = folder
        f = which_config
        cfg = ConfigLoader.default
        if File.exists?(f)
          cfg = YAML.load_file(f)
          if !cfg
            puts "Error loading config from #{f}"
            puts "Using default config"
            cfg = ConfigLoader.default
          end
        end

        if cfg[:version] == nil
          puts "Version 1.0 config file found"
          newcfg = {:version => "2.0", :types => cfg}
          cfg = newcfg
        end


        cfg
      end

      # Returns the default sweep mappings
      def self.default
        {
          version: 2.0,
          types: {
          'music' => ['mp3', 'flac', 'mp4'],
          'docs' => ['pdf'],
          'zips' => ['zip', 'gz', 'bz2'],
          'apps' => ['dmg'],
          'images' => ['jpg','png','bmp'],
          'videos' => ['mov', 'avi', 'm4v'] }
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

  end
end
