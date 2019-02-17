 module SAML
  class Response < OneLogin::RubySaml::Response
    # caution,
    alias_method :onelogin_errors, :errors
    alias_method :onelogin_validate, :validate
    include ActiveModel::Validations

    CLICKED_DENY_MSG = 'Subject did not consent to attribute release'
    TOO_LATE_MSG     = 'Current time is on or after NotOnOrAfter condition'
    TOO_EARLY_MSG    = 'Current time is earlier than NotBefore condition'

    ERROR_INFO = {CLICKED_DENY_MSG => {code: '001', name: :clicked_deny},
                  TOO_LATE_MSG => {code: '002', name: :auth_too_late},
                  TOO_EARLY_MSG => {code: '003', name: :auth_too_early},
                  'unknown' => {code: '007', name: :unknown}
    }
   #'multiple'

    KNOWN_ERRORS = ERROR_INFO.values.collect{ |e| e[:name] }

    validate :onlelogin_rubysaml_validate

    def onlelogin_rubysaml_validate
      # passing true collects all validation errors

      is_valid_result = onelogin_validate(true)


    end

      # errors.each do |error|
      #     errors.add(:base, error)
      #   end


  end
end

# # frozen_string_literal: true

# module SAML
#   class AuthFailHandler
#     attr_accessor :message, :level, :context



#     def error
#       KNOWN_ERRORS.each do |known_error|
#         return known_error if send("#{known_error}?")
#       end

#       only_one_error? ? 'unknown' : 'multiple'
#     end

#     def errors?
#       !@message.nil? && !@level.nil?
#     end

#     private

#     def initialize_errors!
#       @code = '007'
#       KNOWN_ERRORS.each do |known_error|
#         break if send("#{known_error}?")
#       end

#       generic_error_message
#     end

#     def generic_error_message
#       context = {
#         saml_response: {
#           status_message: @saml_response.status_message,
#           errors: @saml_response.errors,
#           code: @code
#         }
#       }
#       set_sentry_params('Other SAML Response Error(s)', :error, context)
#     end

#     def clicked_deny?
#       return false unless only_one_error? && @saml_response.status_message == CLICKED_DENY_MSG
#       set_sentry_params(CLICKED_DENY_MSG, :warn)
#     end

#     def auth_too_late?
#       return false unless only_one_error? && @saml_response.errors[0].include?(TOO_LATE_MSG)
#       set_sentry_params(TOO_LATE_MSG, :warn, @saml_response.errors[0])
#     end

#     def auth_too_early?
#       return false unless only_one_error? && @saml_response.errors[0].include?(TOO_EARLY_MSG)
#       set_sentry_params(TOO_EARLY_MSG, :error, @saml_response.errors[0])
#     end

#     def only_one_error?
#       @saml_response.errors.size == 1
#     end

#     def set_sentry_params(msg, level, ctx = {})
#       @message = 'Login Fail! ' + msg
#       @level   = level
#       @context = ctx
#     end
#   end
# end
