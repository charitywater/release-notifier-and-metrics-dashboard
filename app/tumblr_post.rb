class TumblrPost < Rack::App
  def initialize pt_story, pr, deploy_time, screenshot_urls
    @pt_story = pt_story
    @pr = pr
    @deploy_time = deploy_time
    @screenshot_urls = screenshot_urls
  end

  def post
    client.photo("charity-water-site-updates.tumblr.com", { data: screenshots, caption: "<h3>This change was deployed on #{deploy_time}.</h3><p>#{pt_story.description}</p>" })
  end

  private

  attr_reader :pt_story, :pr, :screenshot_urls

  def client
    @client ||= Tumblr::Client.new
  end

  def screenshots
    screenshot_urls.map { |url| Screenshot.new(url).screenshot_image.path }
  end

  def deploy_time
    tz = TZInfo::Timezone.get('America/New_York')
    tz.utc_to_local(Time.parse(@deploy_time)).strftime('%B %-d, %Y at %I:%M %P')
  end
end