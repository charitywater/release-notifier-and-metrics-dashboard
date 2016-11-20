require 'bundler'
require 'json'
require 'dotenv'
Bundler.require
Loader.autoload
Dotenv.load

class App < Rack::App

  apply_extension :logger

  mount GithubPullRequest

  headers 'Access-Control-Allow-Origin' => '*'

  serializer do |object|
    object.to_s
  end

  desc 'hello'
  get '/hello' do
    'Hello World!'
  end

  post '/ci-post-deploy' do
    webhook_json = JSON.parse(payload)
    @pr_number = webhook_json['commit']['message'].match(/request #(\d+) /)[1]
    logger.info "ci post-deploy webhook received for PR #{pr_number}"
  end

  get '/testing-gh-api/:pr_number' do
    github = GithubPullRequest.new params['pr_number']
    github.retrieve_details.body.to_s
  end

  error StandardError, NoMethodError do |err|
    { error: err.message }
  end

  root '/hello'
end
