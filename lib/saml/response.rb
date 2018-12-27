 module SAML
  class Response < OneLogin::RubySaml::Response

    CONTEXT_MAP = { LOA::MAPPING.invert[1] => 'idme',
                    'dslogon' => 'dslogon',
                    'myhealthevet' => 'myhealthevet',
                    LOA::MAPPING.invert[3] => 'idproof',
                    'multifactor' => 'multifactor',
                    'dslogon_multifactor' => 'dslogon_multifactor',
                    'myhealthevet_multifactor' => 'myhealthevet_multifactor' }.freeze
    UNKNOWN_CONTEXT = 'unknown'


    # will be one of SAML::Response::CONTEXT_MAP.keys
    # this is the real authn-context returned in the response without the use of heuristics
    def real_authn_context
      REXML::XPath.first(decrypted_document, '//saml:AuthnContextClassRef')&.text
    # this is to add additional context when we cannot parse for authn_context
    rescue NoMethodError
      Raven.extra_context(
        base64encodedpayload: Base64.encode64(response),
        attributes: attributes.to_h
      )
      Raven.tags_context(controller_name: 'sessions', sign_in_method: 'not-signed-in:error')
      raise
    end

    def context_key
      CONTEXT_MAP[real_authn_context] || UNKNOWN_CONTEXT
    rescue StandardError
      UNKNOWN_CONTEXT
    end
  end
end