require 'rubygems'
require 'bundler'

Bundler.require(:default)
require "./amazon_ses_endpoint"
run AmazonSesEndpoint
