require 'json'

class PivotalTrackerStory < Rack::App
  def initialize pt_story_number
    @pt_story_number = pt_story_number
  end

  def id
    response_body['id']
  end

  def labels
    response_body['labels']
  end

  def name
    response_body['name']
  end

  def description
    response_body['description']
  end

  private

  attr_reader :pr_number, :pt_story_number

  def retrieve_details
    query_pt_api "projects/#{ENV['PT_PROJECT_ID']}/stories/#{pt_story_number}"
  end

  def response_body
    @response_body ||= JSON.parse(retrieve_details)
  end

  def query_pt_api endpoint
    HTTParty.get(
      pt_base_uri + endpoint,
      headers: {
        'X-TrackerToken' => ENV['PT_API_TOKEN']
      }
    ).body
  end

  def pt_base_uri
    'https://www.pivotaltracker.com/services/v5/'
  end
end
