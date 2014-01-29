require 'newrelic_rpm'

DependencyDetection.defer do
  @name = :dragonfly

  depends_on do
    defined?(::Dragonfly) and not NewRelic::Control.instance['disable_dragonfly']
  end

  executes do
    NewRelic::Agent.logger.debug 'Installing Dragonfly instrumentation'
  end

  executes do
    class Dragonfly::App
      include NewRelic::Agent::Instrumentation::Rack
    end
  end

  executes do
    class Dragonfly::Server
      include ::NewRelic::Agent::MethodTracer
      add_method_tracer :call
    end
  end

  executes do
    class Dragonfly::Job::Step
      include ::NewRelic::Agent::MethodTracer
    end
    [
     Dragonfly::Job::Fetch,
     Dragonfly::Job::Process,
     Dragonfly::Job::Generate,
     Dragonfly::Job::FetchFile,
     Dragonfly::Job::FetchUrl,
    ].each do |klass|
      klass.class_eval do
        add_method_tracer :apply
      end
    end
  end

  executes do
    [
     Dragonfly::ImageMagick::Analysers::ImageProperties,
     Dragonfly::ImageMagick::Generators::Convert,
     Dragonfly::ImageMagick::Generators::Plain,
     Dragonfly::ImageMagick::Generators::Plasma,
     Dragonfly::ImageMagick::Generators::Text,
     Dragonfly::ImageMagick::Processors::Convert,
     Dragonfly::ImageMagick::Processors::Encode,
     Dragonfly::ImageMagick::Processors::Thumb,
    ].each do |klass|
      klass.class_eval do
        include NewRelic::Agent::MethodTracer
        add_method_tracer :call
      end
    end
  end

  executes do
    class Dragonfly::Shell
      include NewRelic::Agent::MethodTracer
      add_method_tracer :run
    end
  end

  executes do
    class Dragonfly::FileDataStore
      include NewRelic::Agent::MethodTracer
      add_method_tracer :write
      add_method_tracer :read
      add_method_tracer :destroy
    end
  end
end

DependencyDetection.defer do
  @name = :dragonfly_s3_data_store

  depends_on do
    defined?(::Dragonfly::S3DataStore) and not NewRelic::Control.instance['disable_dragonfly_s3_data_store']
  end

  executes do
    NewRelic::Agent.logger.debug 'Installing Dragonfly instrumentation'
  end

  executes do
    class Dragonfly::S3DataStore
      include NewRelic::Agent::MethodTracer
      add_method_tracer :write
      add_method_tracer :read
      add_method_tracer :destroy
    end
  end
end
