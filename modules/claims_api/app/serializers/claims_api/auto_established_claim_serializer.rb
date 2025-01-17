# frozen_string_literal: true

module ClaimsApi
  class AutoEstablishedClaimSerializer < EVSSClaimDetailSerializer
    attributes :token, :status, :evss_id

    type :claims_api_auto_established_claims
  end
end
