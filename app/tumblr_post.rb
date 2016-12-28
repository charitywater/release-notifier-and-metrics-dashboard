require 'json'

class TumblrPost < Rack::App
  def initialize pt_story, pr, deploy_time
    @pt_story = pt_story
    @pr = pr
    @deploy_time = deploy_time
  end

  def post
    client.text("charity-water-site-updates.tumblr.com", { title: pr.title, format: 'html', body: "<h3>This change was deployed on #{deploy_time}.</h3><p>#{pt_story.description}</p>" })
  end

  private

  attr_reader :pt_story, :pr

  def client
    @client ||= Tumblr::Client.new
  end

  def deploy_time
    tz = TZInfo::Timezone.get('America/New_York')
    tz.utc_to_local(Time.parse(@deploy_time)).strftime('%B %-d, %Y at %I:%M %P')
  end
end