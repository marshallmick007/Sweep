require './test_helper'

def test_downloads_non_descructive
  loader = Sweep::Config::ConfigLoader.new File.expand_path('~/Documents')
  sweeper = Sweep::LogOnlySweeper.new loader

  sweeper.sweep
end

test_downloads_non_descructive
