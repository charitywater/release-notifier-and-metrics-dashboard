require 'spec_helper'
require 'rack/app/test'

describe App do

  include Rack::App::Test

  rack_app described_class

  describe '/hello' do
    # example for params and headers and payload use
    subject {
      get(url: '/hello', params: {'dog' => 'meat'}, headers: {'X-Cat' => 'fur'}, payload: 'example string')
    }

    it 'responds with a 200 status' do
      expect(subject.status).to eq 200
    end

    it 'responds with a simple string' do
      expect(subject.body).to eq 'Hello World!'
    end
  end

  describe '/ci-post-deploy' do
    subject {
      post(url: '/ci-post-deploy', payload: semaphore_webhook_body)
    }

    let(:semaphore_webhook_body) { {
      'server_name':'example-production',
      'result':'passed',
      'finished_at':'2016-11-19T04:40:59Z',
      'url':'https://github.com/example/app/commit/dea56cb422406717f6dde760ae1c6b139587fa96',
      'author_name':'John Cat',
      'message':'Merge pull request #4096 from example/example-patch-1\n\nExample Amazing PR Title'
    } }

    it 'logs the PR that was merged' do
      allow(App).to receive(:payload) { semaphore_webhook_body }

      expect(subject.status).to eq 200
    end
  end
end
