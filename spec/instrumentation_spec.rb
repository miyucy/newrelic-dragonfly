require 'spec_helper'

describe Newrelic::Dragonfly do
  include Rack::Test::Methods

  let(:app) { Dragonfly.app(:images).configure_with(:imagemagick) }
  let(:uid) { app.store fixture('sample.png') }

  let(:agent) { NewRelic::Agent.instance }

  it 'include rack instrumentation' do
    get app.create.fetch(uid).url
    agent.transaction_sampler.last_sample.to_s.should include 'Controller/Rack/Dragonfly::App'
  end

  it 'include job instrumentation' do
    get app.create.fetch(uid).process(:thumb, '32x32').encode(:jpg).url
    agent.transaction_sampler.last_sample.to_s.should include 'Dragonfly::Job::Fetch'
    agent.transaction_sampler.last_sample.to_s.should include 'Dragonfly::Job::Process'
    agent.transaction_sampler.last_sample.to_s.should include 'Dragonfly::ImageMagick::Processors::Thumb'
    agent.transaction_sampler.last_sample.to_s.should include 'Dragonfly::ImageMagick::Processors::Encode'
  end
end
