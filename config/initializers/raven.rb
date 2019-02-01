# frozen_string_literal: true

require 'sentry/processor/email_sanitizer'
Raven.configure do |config|
  config.dsn = Settings.sentry.dsn if Settings.sentry.dsn

  # filters emails from Sentry exceptions and log messsges
  config.processors << Sentry::Processor::EmailSanitizer
  config.processors << Sentry::Processor::PIISanitizer
  config.processors << Sentry::Processor::LogAsWarning

  config.excluded_exceptions += ['Sentry::IgnoredError']

  config.before_send = -> event, hint do
    return unless hint[:exception] && hint[:exception].is_a?(Common::Exceptions::BaseError)

    ex = hint[:exception]

    # '{{ default }}'
    event.fingerprint = ex.respond_to?(:key) ? [hint[:exception].key] : ['{{ default }}']
    event.tags = event.tags.merge!(key: hint[:exception].key)
    event
  end

  config.async = -> event { SentryJob.perform_async(event) }
end
