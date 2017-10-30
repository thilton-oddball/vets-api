# frozen_string_literal: true
require 'rails_helper'

describe EVSS::Claims::Service do
  let(:current_user) { FactoryGirl.create(:loa3_user) }
  let(:claims_service) { described_class.new(current_user) }

  subject { claims_service }

  context 'with headers' do
    let(:evss_id) { 189_625 }

    it 'should get claims' do
      VCR.config do |c|
        c.allow_http_connections_when_no_cassette = true
      end
      puts subject.all_claims.body
      puts described_class.new(create(:loa3_user, ssn: '234234234')).all_claims.body

      # VCR.use_cassette('evss/claims/claims') do
      #   response = subject.all_claims
      #   expect(response).to be_success
      # end
    end

    it 'should post a 5103 waiver' do
      VCR.use_cassette('evss/claims/set_5103_waiver') do
        response = subject.request_decision(evss_id)
        expect(response).to be_success
      end
    end
  end
end
