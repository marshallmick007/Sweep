module Sweep
  module Matcher
    class UnhandledMatcher < MatcherBase

      def initialize
        @files = []
      end
      # for each regex in pattern list, 
      # does the file match the pattern?
      def is_match?(file)
        return Match.new file, ''
      end

      def process(match)
        @files.push match.file
      end

      def output
        puts ""
        puts "Unable to clean up:"
        @files.each do |f|
          puts f
        end
      end
    end
  end
end

