module Sweep
  module Matcher
    class MatcherBase
      attr_accessor :basedir
      # Process a match
      def process(match, mode=:test)
        if mode != :test
          puts "Moving " + match.file + " -> " + match.destination
          #Move the file into the folder
          FileUtils.mkdir_p(match.destination) unless Dir.exists?(match.destination)
          FileUtils.move(match.file, "#{match.destination}/#{match.file}")
        end
      end

      def compute_destination(destination)
        return File.expand_path(File.join(@basedir, destination))
      end
    end
  end
end
