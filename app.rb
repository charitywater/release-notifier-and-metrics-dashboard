require 'bundler'
require 'json'
require 'dotenv'
Bundler.require
Loader.autoload

class App < Rack::App

  mount GithubPullRequest

  headers 'Access-Control-Allow-Origin' => '*',
          'Access-Control-Expose-Headers' => 'X-My-Custom-Header, X-Another-Custom-Header'

  serializer do |object|
    object.to_s
  end

  desc 'hello'
  get '/hello' do
    'Hello World!'
  end

  error StandardError, NoMethodError do |err|
    { error: err.message }
  end

  root '/hello'
end
