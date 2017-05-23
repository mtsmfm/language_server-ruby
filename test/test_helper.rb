$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'bundler'
Bundler.require(:default, :development)

require 'minitest/autorun'
