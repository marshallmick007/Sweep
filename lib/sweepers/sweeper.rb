require 'fileutils'

module Sweep
  class Sweeper

    attr_accessor :folder
    attr_accessor :mapping
    #attr_accessor :config

    def initialize(config_loader)
      @folder = config_loader.folder
      @mapping = config_loader.config
    end

    # Loads the config file category mappings
    def map_config
      m = Hash.new
      @mapping[:types].each do |k,v|
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

end
