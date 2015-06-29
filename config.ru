# Gemfile

require 'rubygems'

require "bundler/setup"

require 'sinatra'

require 'json'

require 'rest-client'

set :run, false

set :raise_errors, true

run Sinatra::Application
