module Sweep
  module Matcher
    class Match
      attr_reader :file
      attr_reader :destination

      def initialize(file, destination)
        @file = file
        @destination = destination
      end
    end
  end
end
