module Sweep
  module Matcher
    class ExtensionMatcher < MatcherBase
      def initialize(extensionmap)
        @extensionmap = extensionmap
      end

      def is_match?(file)
        ext = extension(file)
        if @extensionmap.key?(ext)
          return Match.new file, compute_destination(@extensionmap[ext])
        end
        return nil
      end

      def extension(file)
        ext = File.extname(file).downcase
        ext.slice!(0)  #remove the '.'
        ext
      end 
    end
  end
end
