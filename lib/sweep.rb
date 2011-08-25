# Load all sub-modules 

require 'config/config_loader'
require 'sweepers/sweeper'
require 'sweepers/log_only_sweeper'

# Load the Sweeper namespace
include Sweeper

