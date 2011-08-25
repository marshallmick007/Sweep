require './test_helper'

def config_V1
  {
    'music' => ['mp3', 'flac', 'mp4'],
    'docs' => ['pdf'],
    'zips' => ['zip', 'gz', 'bz2'],
    'apps' => ['dmg'],
    'images' => ['jpg','png','bmp'],
    'videos' => ['mov', 'avi', 'm4v']
  }
end

def config_V2
  {
    version: 2.0,
    types: {
    'music' => ['mp3', 'flac', 'mp4'],
    'docs' => ['pdf'],
    'zips' => ['zip', 'gz', 'bz2'],
    'apps' => ['dmg'],
    'images' => ['jpg','png','bmp'],
    'videos' => ['mov', 'avi', 'm4v'] }
  }
end



cfg = config_V1
puts cfg[:version] == nil

