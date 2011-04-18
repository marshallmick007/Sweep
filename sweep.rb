#!/usr/bin/env ruby


require 'fileutils'
require 'yaml'

CONFIG_FILE = '.sweep.yaml'
DEFAULT_CONFIG='~/' + CONFIG_FILE


class ConfigLoader
    
    def init(folder)
        s = Sweeper.new(folder)
        s.mapping = load(s)
        
        s
    end

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

class Sweeper

    attr_accessor :folder
    attr_accessor :mapping
    attr_accessor :config

    def initialize(folder)
        @folder = folder
    end

    def local_config_exists?
        return File.exists? local_config_file
    end

    def local_config_file
         File.join(File.expand_path(@folder), CONFIG_FILE)
    end

    def which_config
        if local_config_exists?
            local_config_file
        else
            DEFAULT_CONFIG
        end
    end

    def map_config
        m = Hash.new
        @mapping.each do |k,v|
            v.each do |ext|
                m[ext] = k
            end
        end

        m
    end

    def sweep
        m = map_config
        unmapped = []
        Dir.foreach @folder do |file|
            FileUtils.cd @folder

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

    def test_map
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

    cl = ConfigLoader.new

    s = cl.init a

    s.sweep
end

