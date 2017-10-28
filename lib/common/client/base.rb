# frozen_string_literal: true
require 'faraday'
require 'common/client/errors'
require 'common/models/collection'
require 'sentry_logging'

module Common
  module Client
    class Base
      include SentryLogging

      class << self
        def configuration(configuration = nil)
          @configuration ||= configuration.instance
        end
      end

      private

      def config
        self.class.configuration
      end

      # memoize the connection from config
      def connection
        @connection ||= config.connection
      end

      def perform(method, path, params, headers = nil, &block)
        raise NoMethodError, "#{method} not implemented" unless config.request_types.include?(method)

        send(method, path, params || {}, headers || {}, &block)
      end

      def request(method, path, params = {}, headers = {})
        data = {}

        raise_not_authenticated if headers.keys.include?('Token') && headers['Token'].nil?
        env = connection.send(method.to_sym, path, params) do |request|
          request.headers.update(headers)
          yield(request) if block_given?
          data[:request] = request.to_h
        end.env

        if config.class == EVSS::Claims::Configuration
          data[:response_headers] = env.response_headers
          data[:response_status] = env.status
          log_message_to_sentry('request response data', :info, data: Base64.encode64(data.to_json))
        end

        env
      rescue Timeout::Error, Faraday::TimeoutError
        log_message_to_sentry(
          "Timeout while connecting to #{config.service_name} service", :error, extra_context: { url: config.base_path }
        )
        raise Common::Exceptions::GatewayTimeout
      rescue Faraday::ParsingError => e
        # Faraday::ParsingError is a Faraday::ClientError but should be handled by implementing service
        raise e
      rescue Faraday::ClientError => e
        client_error = Common::Client::Errors::ClientError.new(
          e.message,
          e.response&.dig(:status),
          e.response&.dig(:body)
        )
        raise client_error
      end

      def get(path, params, headers = base_headers, &block)
        request(:get, path, params, headers, &block)
      end

      def post(path, params, headers = base_headers, &block)
        request(:post, path, params, headers, &block)
      end

      def put(path, params, headers = base_headers, &block)
        request(:put, path, params, headers, &block)
      end

      def delete(path, params, headers = base_headers, &block)
        request(:delete, path, params, headers, &block)
      end

      def raise_not_authenticated
        raise Common::Client::Errors::NotAuthenticated, 'Not Authenticated'
      end
    end
  end
end
