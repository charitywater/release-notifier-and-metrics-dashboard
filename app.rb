require 'json'
require 'bundler'
Bundler.require

if ENV['RACK_ENV'] == 'development'
  require 'dotenv'
  Dotenv.load
end

Loader.autoload

class App < Rack::App

  apply_extension :logger

  mount GithubPullRequest
  mount PivotalTrackerStory

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
    pr = GithubPullRequest.new pr_number
    pt_story = PivotalTrackerStory.new pr.pt_story_number
    tumblr_post = TumblrPost.new pt_story, pr, webhook_json['finished_at'], ['https://www.charitywater.org/', 'https://www.charitywater.org/about/']
    tumblr_post.post
  end

  get '/testing-gh-api/:pr_number' do
    github = GithubPullRequest.new params['pr_number']
    github.retrieve_details.body.to_s
  end

  error StandardError, NoMethodError do |err|
    { error: err.message }
  end

  root '/hello'

  private

  attr_reader :pr_number
end
