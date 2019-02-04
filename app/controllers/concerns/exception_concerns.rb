# frozen_string_literal: true

module ExceptionConcerns
  extend ActiveSupport::Concern

  def log_exception(exception)
    if skip_sentry_exception_types.include?(exception.class)
      Rails.logger.error(exception.message, backtrace: exception.backtrace)
    else
      log_exception_to_sentry(exception, add_extra_context(exception))
    end
  end

  def add_extra_context(exception)
    extra = exception.respond_to?(:errors) ? { errors: exception.errors.map(&:to_hash) } : {}
    return extra unless exception.is_a?(Common::Exceptions::BackendServiceException)

    if current_user.present?
      # Add additional user specific context to the logs
      extra[:icn] = current_user.icn
      extra[:mhv_correlation_id] = current_user.mhv_correlation_id
    end
    extra
  end

  def map_to_va_exception(exception)
    case exception
    when Pundit::NotAuthorizedError
      Common::Exceptions::Forbidden.new(detail: 'User does not have access to the requested resource')
    when ActionController::ParameterMissing
      Common::Exceptions::ParameterMissing.new(exception.param)
    when ActionController::UnknownFormat
      Common::Exceptions::UnknownFormat.new
    when Common::Exceptions::BaseError
      exception
    when Breakers::OutageException
      Common::Exceptions::ServiceOutage.new(exception.outage)
    when Common::Client::Errors::ClientError
      Common::Exceptions::ServiceOutage.new(nil, detail: 'Backend Service Outage')
    else
      Common::Exceptions::InternalServerError.new(exception)
    end
  end
end
