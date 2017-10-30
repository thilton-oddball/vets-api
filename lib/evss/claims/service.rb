# frozen_string_literal: true
# EVSS::Claims::Service.new(wesley).all_claims
module EVSS
  module Claims
    class Service < EVSS::Service
      DEFAULT_TIMEOUT = 120

      configuration EVSS::Claims::Configuration

      def initialize(current_user)
        @current_user = current_user
      end

      def all_claims
        perform_with_user_headers(:get, '', nil)
      end

      def find_claim_by_id(claim_id)
        perform_with_user_headers(
          :post,
          'vbaClaimStatusService/getClaimDetailById',
          { id: claim_id }.to_json
        )
      end

      def request_decision(claim_id)
        perform_with_user_headers(
          :post,
          'vbaClaimStatusService/set5103Waiver',
          {
            claimId: claim_id,
            systemName: SYSTEM_NAME
          }.to_json
        )
      end
    end
  end
end
