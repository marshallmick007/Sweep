module Sweep
  module Matcher
    class PatternMatcher < MatcherBase

      def initialize(patternlist)
        @patternlist = patternlist
      end

      # for each regex in pattern list, 
      # does the file match the pattern?
      def is_match?(file)

        @patternlist.keys.each do |regex|
          if file =~ regex
            return Match.new file, compute_destination(@patternlist[regex])
          end
        end
        return nil
      end
    end
  end
end

