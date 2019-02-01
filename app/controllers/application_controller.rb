# frozen_string_literal: true

require 'feature_flipper'
require 'common/exceptions'
require 'common/client/errors'
require 'saml/settings_service'
require 'sentry_logging'
require 'aes_256_cbc_encryptor'

class ApplicationController < ActionController::API
  include AuthenticationAndSSOConcerns
  include Pundit
  include SentryLogging
  include ExceptionConcerns

  SKIP_SENTRY_EXCEPTION_TYPES = [
    Common::Exceptions::Unauthorized,
    Common::Exceptions::RoutingError,
    Common::Exceptions::Forbidden,
    Breakers::OutageException
  ].freeze

  prepend_before_action :block_unknown_hosts, :set_app_info_headers
  # See Also AuthenticationAndSSOConcerns for more before filters
  skip_before_action :authenticate, only: %i[cors_preflight routing_error]
  before_action :set_tags_and_extra_context

  rescue_from 'Exception' do |exception|
    log_exception(exception)
    va_exception = map_to_va_exception(exception)
    headers['WWW-Authenticate'] = 'Token realm="Application"' if va_exception.is_a?(Common::Exceptions::Unauthorized)
    render json: { errors: va_exception.errors }, status: va_exception.status_code
  end

  def tag_rainbows
    Sentry::TagRainbows.tag
  end

  def cors_preflight
    head(:ok)
  end

  def routing_error
    raise Common::Exceptions::RoutingError, params[:path]
  end

  def clear_saved_form(form_id)
    InProgressForm.form_for_user(form_id, current_user)&.destroy if current_user
  end

  # I'm commenting this out for now, we can put it back in if we encounter it
  # def action_missing(m, *_args)
  #   Rails.logger.error(m)
  #   raise Common::Exceptions::RoutingError
  # end

  private

  attr_reader :current_user

  # returns a Bad Request if the incoming host header is unsafe.
  def block_unknown_hosts
    return if controller_name == 'example'
    raise Common::Exceptions::NotASafeHostError, request.host unless Settings.virtual_hosts.include?(request.host)
  end

  def skip_sentry_exception_types
    SKIP_SENTRY_EXCEPTION_TYPES
  end

  def set_tags_and_extra_context
    Thread.current['request_id'] = request.uuid
    Raven.extra_context(request_uuid: request.uuid)
    Raven.user_context(user_context) if current_user
    Raven.tags_context(tags_context)
  end

  def user_context
    {
      uuid: current_user&.uuid,
      authn_context: current_user&.authn_context,
      loa: current_user&.loa,
      mhv_icn: current_user&.mhv_icn
    }
  end

  def tags_context
    {
      controller_name: controller_name,
      sign_in_method: current_user.present? ? current_user.identity.sign_in : 'not-signed-in'
    }
  end

  def set_app_info_headers
    headers['X-GitHub-Repository'] = 'https://github.com/department-of-veterans-affairs/vets-api'
    headers['X-Git-SHA'] = AppInfo::GIT_REVISION
  end

  def saml_settings(options = {})
    callback_url = URI.parse(Settings.saml.callback_url)
    callback_url.host = request.host
    options.reverse_merge!(assertion_consumer_service_url: callback_url.to_s)
    SAML::SettingsService.saml_settings(options)
  end

  def pagination_params
    {
      page: params[:page],
      per_page: params[:per_page]
    }
  end

  def render_job_id(jid)
    render json: { job_id: jid }, status: 202
  end

  def append_info_to_payload(payload)
    super
    payload[:session] = Session.obscure_token(session[:token]) if session && session[:token]
  end
end
