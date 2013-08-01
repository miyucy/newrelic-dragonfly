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
     Dragonfly::Job::Encode,
     Dragonfly::Job::Generate,
     Dragonfly::Job::FetchFile,
     Dragonfly::Job::FetchUrl
    ].each do |klass|
      klass.class_eval do
        add_method_tracer :apply
      end
    end
  end

  executes do
    class Dragonfly::Analyser
      include NewRelic::Agent::MethodTracer
      add_method_tracer :analyse
    end
    class Dragonfly::Encoder
      include NewRelic::Agent::MethodTracer
      add_method_tracer :encode
    end
    class Dragonfly::Generator
      include NewRelic::Agent::MethodTracer
      add_method_tracer :generate
    end
    class Dragonfly::Processor
      include NewRelic::Agent::MethodTracer
      add_method_tracer :process
    end
    module Dragonfly::Shell
      include NewRelic::Agent::MethodTracer
      add_method_tracer :run
    end
  end

  executes do
    class Dragonfly::ImageMagick::Analyser
      include NewRelic::Agent::MethodTracer
      add_method_tracer :width
      add_method_tracer :height
      add_method_tracer :aspect_ratio
      add_method_tracer :portrait?
      add_method_tracer :portrait
      add_method_tracer :landscape?
      add_method_tracer :landscape
      add_method_tracer :depth
      add_method_tracer :number_of_colours
      add_method_tracer :number_of_colors
      add_method_tracer :format
      add_method_tracer :image?
    end
    class Dragonfly::ImageMagick::Encoder
      include NewRelic::Agent::MethodTracer
      add_method_tracer :encode
    end
    class Dragonfly::ImageMagick::Generator
      include NewRelic::Agent::MethodTracer
      add_method_tracer :plain
      add_method_tracer :plasma
      add_method_tracer :text
    end
    class Dragonfly::ImageMagick::Processor
      include NewRelic::Agent::MethodTracer
      add_method_tracer :resize
      add_method_tracer :auto_orient
      add_method_tracer :crop
      add_method_tracer :flip
      add_method_tracer :flop
      add_method_tracer :greyscale
      add_method_tracer :grayscale
      add_method_tracer :resize_and_crop
      add_method_tracer :rotate
      add_method_tracer :strip
      add_method_tracer :thumb
      add_method_tracer :convert
    end
    module Dragonfly::ImageMagick::Utils
      include NewRelic::Agent::MethodTracer
      add_method_tracer :convert
      add_method_tracer :identify
      add_method_tracer :raw_identify
    end
  end

  executes do
    class Dragonfly::DataStorage::FileDataStore
      include NewRelic::Agent::MethodTracer
      add_method_tracer :store
      add_method_tracer :retrieve
      add_method_tracer :destroy
    end
  end
end

DependencyDetection.defer do
  @name = :dragonfly_s3datastore

  depends_on do
    defined?(::Fog) and not NewRelic::Control.instance['disable_dragonfly_s3datastore']
  end

  executes do
    NewRelic::Agent.logger.debug 'Installing Dragonfly instrumentation'
  end

  executes do
    class Dragonfly::DataStorage::S3DataStore
      include NewRelic::Agent::MethodTracer
      add_method_tracer :store
      add_method_tracer :retrieve
      add_method_tracer :destroy
    end
  end
end
