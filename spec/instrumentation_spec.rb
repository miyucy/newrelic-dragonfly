require 'spec_helper'

describe Newrelic::Dragonfly do
  include Rack::Test::Methods

  let(:root_path) { Dir.mktmpdir }
  after { FileUtils.remove_entry_secure root_path }

  let(:app) { Dragonfly.app(:images) }
  before { app.use_datastore :file, root_path: root_path }

  let(:uid) { app.store fixture('sample.png') }

  let(:agent) { NewRelic::Agent.instance }

  it 'include rack instrumentation' do
    get app.create.fetch(uid).url
    agent.transaction_sampler.last_sample.to_s.should include 'Controller/Rack/Dragonfly::App'
  end

  it 'include file instrumentation' do
    get app.create.fetch(uid).url
    puts agent.transaction_sampler.last_sample.to_s
    agent.transaction_sampler.last_sample.to_s.should include 'Dragonfly::FileDataStore'
  end

  it 'include job instrumentation' do
    get app.create.fetch(uid).process(:thumb, '32x32').encode(:jpg).url
    agent.transaction_sampler.last_sample.to_s.should include 'Dragonfly::Job::Fetch'
    agent.transaction_sampler.last_sample.to_s.should include 'Dragonfly::Job::Process'
    agent.transaction_sampler.last_sample.to_s.should include 'Dragonfly::ImageMagick::Processors::Thumb'
    agent.transaction_sampler.last_sample.to_s.should include 'Dragonfly::ImageMagick::Processors::Encode'
  end
end

describe Newrelic::Dragonfly, Dragonfly::S3DataStore do
  include Rack::Test::Methods

  let(:app) { Dragonfly.app(:images) }
  before { app.use_datastore :s3, bucket_name: 'dragonfly', access_key_id: 'dummy', secret_access_key: 'dummy' }

  let(:uid) { app.store fixture('sample.png') }

  let(:agent) { NewRelic::Agent.instance }

  it 'include s3 instrumentation' do
    get app.create.fetch(uid).url
    agent.transaction_sampler.last_sample.to_s.should include 'Dragonfly::S3DataStore'
  end
end
