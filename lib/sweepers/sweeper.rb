require 'fileutils'

#puts 'loading...' + File.expand_path( File.dirname(__FILE__) + '/matchers')
#Dir[File.dirname(__FILE__) + '/matchers/*.rb'].each do |file|
#  puts 'loading ' + File.basename(file, File.extname(file))

#  require File.basename(file, File.extname(file))
#end


matchers = File.expand_path(File.join(File.dirname(__FILE__), 'matchers'))
#ext = File.expand_path(File.join(root, 'ext', 'libxml'))

$LOAD_PATH << matchers

require 'matcher'

#include Sweep::Matcher
module Sweep

  class Sweeper

    #include Sweep::Matcher

    attr_accessor :folder
    attr_accessor :config
    #attr_accessor :config

    def initialize(config_loader)
      @folder = config_loader.folder
      @config = config_loader.config

      process_config
    end


    def process_config
      @handlers = Hash.new
      @handlers[:types] = ExtensionMatcher.new map_config_extensions
      @handlers[:patterns] = PatternMatcher.new map_config_patterns
      @handlers[:unhandled] = UnhandledMatcher.new

      @handlers.keys.each { |k| @handlers[k].basedir = @folder }
    end

    # Loads the config file category mappings
    def map_config_extensions
      @extensions = Hash.new
      @config["types"].each do |k,v|
        puts "#{k} => #{v}"
        v.each do |ext|
          @extensions[ext] = k
        end
      end
      return @extensions
    end

    def map_config_patterns
      @patterns = Hash.new
      @config["patterns"].each do |k,v|
        v.each do |pattern|
          @patterns[pattern] = k
        end
      end
      return @patterns
    end

    # Move files in the target directory to the cleaned up
    # folders specified in the map_config
    def sweep(mode=:test)
      unmapped = []
      # For each file in the folder @folder
      Dir.foreach @folder do |file|
        FileUtils.cd @folder
        h = [:patterns, :types, :unhandled]

        # If we are indeed looking at a file and not a directory
        if File.file?(file)
          handled = false
          h.each do |key|
            unless handled
              match =  @handlers[key].is_match? file

              if match
                puts "Match for #{file} -> #{match.destination}"
                handled = true
                @handlers[key].process match, mode
              end
            end
          end

          #unless handle_pattern_match file
          #  unless handle_extension_match file
          #    handle_no_match file
          #  end
          #end

          #ext = File.extname(file).downcase
          #ext.slice!(0)
          #if m.key?(ext)
            ##Check to make sure that m.value folder exists
            ##if not, create it
            #target_dir = @folder + "/" + m[ext]
            #puts "Moving #{file} to #{target_dir}"

            ##Move the file into the folder
            #FileUtils.mkdir_p(target_dir) unless Dir.exists?(target_dir)
            #FileUtils.move(file, "#{target_dir}/#{file}")
          #else
            #unmapped.push file
          #end
        end
      end

      @handlers[:unhandled].output

    end

    def handle_pattern_match(file)
      handled = PatternMatcher.new.is_match?(file, @config["patterns"])
    end

    def handle_extension_match(file)

    end

    def handle_no_match(file)

    end
  end

end
