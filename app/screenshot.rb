require 'screencap'

class Screenshot < Rack::App
  def initialize url
    @url = url
  end

  def screenshot_image
    fetcher = Screencap::Fetcher.new(url)
    fetcher.fetch(
      :output => "tmp/#{remove_protocol_and_dasherize(url)}.png",
      width: 1024,
      height: 5000
    )
  end

  private

  attr_reader :url

  def remove_protocol_and_dasherize(url)
    url.gsub(/http.*:\/\//, '').gsub(/\/|\.|:/, '-')
  end
end
