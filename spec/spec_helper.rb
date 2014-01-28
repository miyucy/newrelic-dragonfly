require 'rubygems'
require 'newrelic_rpm'
require 'dragonfly'
require 'bundler/setup'
Bundler.require :default, :test

RSpec.configure do |config|
  config.before(:suite) do
    Fog.mock!
  end

  config.before(:suite) do
    Dragonfly.logger = Logger.new STDOUT
    Dragonfly.app(:images).configure do
      plugin :imagemagick
    end
  end

  config.before(:suite) do
    NewRelic::Agent.manual_start
    DependencyDetection.detect!
  end

  config.before(:each) do
    agent = NewRelic::Agent.instance
    agent.stats_engine.clear_stats
    agent.transaction_sampler.reset!
  end
end

def fixture(name)
  File.new(File.expand_path(File.join(__FILE__, '..', 'fixtures', name)))
end
