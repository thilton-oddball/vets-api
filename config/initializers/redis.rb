# frozen_string_literal: true

# environment specific redis host and port (see: config/redis.yml)
REDIS_CONFIG = Rails.application.config_for(:redis).freeze
# set the current global instance of Redis based on environment specific config
Redis.current = Redis.new(REDIS_CONFIG['redis'])

Redis::Client.class_eval do
  alias_method :call_without_statsd, :call

  def call(*args, &block)
    StatsD.measure('redis.call.duration') do
      call_without_statsd(*args, &block)
    end
  end

  alias_method :call_pipeline_without_statsd, :call_pipeline

  def call_pipeline(*args, &block)
    StatsD.measure('redis.call_pipeline.duration') do
      call_pipeline_without_statsd(*args, &block)
    end
  end
end
