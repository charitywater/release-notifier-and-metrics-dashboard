require 'spec_helper'
require 'rack/app/test'

describe App do

  include Rack::App::Test

  rack_app described_class

  describe '/hello' do
    # example for params and headers and payload use
    subject{ get(url: '/hello', params: {'dog' => 'meat'}, headers: {'X-Cat' => 'fur'}, payload: 'example string') }

    it { expect(subject.status).to eq 200 }

    it { expect(subject.body).to eq "Hello World!" }
  end
end
