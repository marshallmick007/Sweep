require 'fileutils'

module Sweeper
  # Performs a test sweep against the target directory, 
  # using the target config mappings. No files are moved
  # during this process
  class LogOnlySweeper < Sweeper
    def sweep
      m = map_config
      m.each do |k,v|
        puts "#{k}: #{v}"
      end
      filemap = Hash.new
      unmapped = []
      Dir.foreach @config.folder do |file|
        FileUtils.cd @config.folder

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

end
