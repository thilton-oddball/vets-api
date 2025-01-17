# frozen_string_literal: true

module VA0994
  FORM_ID = '22-0994'

  class FormPaymentAccountInformation
    include Virtus.model

    attribute :account_type, String
    attribute :account_number, String
    attribute :routing_number, String
    attribute :bank_name, String
  end
end

class FormProfiles::VA0994 < FormProfile
  attribute :payment_information, VA0994::FormPaymentAccountInformation

  def prefill(user)
    @payment_information = initialize_payment_information(user)
    super(user)
  end

  def metadata
    {
      version: 0,
      prefill: true,
      returnUrl: '/applicant/information'
    }
  end

  private

  def initialize_payment_information(user)
    return {} unless user.authorize :evss, :access?

    service = EVSS::PPIU::Service.new(user)
    response = service.get_payment_information
    raw_account = response.responses.first&.payment_account

    if raw_account
      VA0994::FormPaymentAccountInformation.new(
        account_type: raw_account&.account_type&.capitalize,
        account_number: mask(raw_account&.account_number),
        routing_number: mask(raw_account&.financial_institution_routing_number),
        bank_name: raw_account&.financial_institution_name
      )
    else
      {}
    end
  rescue StandardError => e
    Rails.logger.error "Failed to retrieve PPIU data: #{e.message}"
    {}
  end

  def mask(number)
    number.gsub(/.(?=.{4})/, '*')
  end
end
