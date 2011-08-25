require './test_helper'

def test_output(cfg)
  #puts default.class
  cfg.each do |key, value|
    puts key
    cfg[key].each do |ext|
      puts "\t#{ext}"
    end
  end
end

def test_default_map
  loader = Sweep::Config::ConfigLoader.new

  test_output Sweep::Config::ConfigLoader.default
end

def test_current_dir
  loader = Sweep::Config::ConfigLoader.new
  cfg = loader.load('.')
  test_output cfg
end


test_current_dir
