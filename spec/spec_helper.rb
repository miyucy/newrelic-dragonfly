require 'rubygems'
require 'newrelic_rpm'
require 'dragonfly'
require 'bundler/setup'
Bundler.require :default, :test

RSpec.configure do |config|
  config.before(:suite) do
    Dragonfly[:images].configure_with(:imagemagick)
  end

  config.before(:suite) do
    NewRelic::Agent.manual_start
    DependencyDetection.detect!
  end

  config.before(:each) do
    @engine = NewRelic::Agent.instance.stats_engine
    @engine.clear_stats
  end
end

def fixture(name)
  File.new(File.expand_path(File.join(__FILE__, '..', 'fixtures', name)))
end
