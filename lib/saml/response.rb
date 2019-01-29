# frozen_string_literal: true

module SAML
  class Response < OneLogin::RubySaml::Response
    CLICKED_DENY_MSG = 'Subject did not consent to attribute release'
    TOO_LATE_MSG     = 'Current time is on or after NotOnOrAfter condition'
    TOO_EARLY_MSG    = 'Current time is earlier than NotBefore condition'
    OTHER_MSG        = 'Other SAML Response Error(s)'


    ERROR_TYPES = {multiple: {message: '', level: :warn, code: ''},
                   clicked_deny:  {message: CLICKED_DENY_MSG, level: :warn, code: '001'},
                   auth_too_late: {message: TOO_LATE_MSG, level: :warn, code: '002'},
                   auth_too_early: {message: TOO_EARLY_MSG, level: :error, code: '003'},
                   unknown: {message: '', level: :error, code: ''} #todo code
                  }

    def errors?
      errors.present?
    end

    def error_type
      @error_type ||= if errors.size > 1
        :multiple
      elsif status_message == CLICKED_DENY_MSG
        :clicked_deny
      elsif @saml_response.errors[0].include?(TOO_LATE_MSG)
        :auth_too_late
      elsif @saml_response.errors[0].include?(TOO_EARLY_MSG)
        :auth_too_early
      else
        :unknown
      end
    end

    def error_level
      ERROR_TYPES[error_type][:level]
    end

    def error_message
      'Login Fail! ' + ERROR_TYPES[error_type][:message]
    end

    def error_code
      ERROR_TYPES[error_type][:code]
    end

    def error_context
      {status_message: @saml_response.status_message,
       errors: @saml_response.errors}
    end
  end
end
