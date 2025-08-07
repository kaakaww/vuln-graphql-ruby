ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup' # Set up gems listed in the Gemfile.
require 'logger' # Ensure logger is loaded before Rails tries to use it
# require 'bootsnap/setup' # Speed up boot time by caching expensive operations.
