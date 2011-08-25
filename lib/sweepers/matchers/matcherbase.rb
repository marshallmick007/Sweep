module Sweep
  module Matcher
    class MatcherBase
      attr_accessor :basedir
      # Process a match
      def process(match)
        puts "Moving " + match.file + " -> " + match.destination

        #Move the file into the folder
        #FileUtils.mkdir_p(target_dir) unless Dir.exists?(target_dir)
        #FileUtils.move(file, "#{target_dir}/#{file}")

      end

      def compute_destination(destination)
        return File.expand_path(File.join(@basedir, destination))
      end
    end
  end
end
