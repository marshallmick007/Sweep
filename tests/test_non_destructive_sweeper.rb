require './test_helper'

def test_downloads_non_descructive
  loader = Sweeper::Config::ConfigLoader.new '~/Documents'
  sweeper = Sweeper::LogOnlySweeper.new loader.config

  sweeper.sweep
end

test_downloads_non_descructive
