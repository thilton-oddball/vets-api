# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Disability Claims ', type: :request do
  let(:headers) do
    { 'X-VA-SSN': '796043735',
      'X-VA-First-Name': 'WESLEY',
      'X-VA-Last-Name': 'FORD',
      'X-VA-EDIPI': '1007697216',
      'X-Consumer-Username': 'TestConsumer',
      'X-VA-User': 'adhoc.test.user',
      'X-VA-Birth-Date': '1986-05-06T00:00:00+00:00',
      'X-VA-Gender': 'M' }
  end
  describe '#526' do
    let(:data) { File.read(Rails.root.join('modules', 'claims_api', 'spec', 'fixtures', 'form_526_json_api.json')) }
    let(:path) { '/services/claims/v0/forms/526' }

    it 'should return a successful response with all the data' do
      VCR.use_cassette('evss/intent_to_file/active_compensation_future_date') do
        klass = EVSS::DisabilityCompensationForm::ServiceAllClaim
        allow_any_instance_of(klass).to receive(:validate_form526).and_return(true)
        post path, params: data, headers: headers
        parsed = JSON.parse(response.body)
        expect(parsed['data']['type']).to eq('claims_api_auto_established_claims')
        expect(parsed['data']['attributes']['status']).to eq('pending')
      end
    end

    it 'should return an unsuccessful response with an error message' do
      VCR.use_cassette('evss/intent_to_file/active_compensation') do
        post path, params: data, headers: headers
        parsed = JSON.parse(response.body)
        expect(response.status).to eq(422)
        expect(parsed['errors'].first['details']).to eq('Intent to File Expiration Date not valid, resubmit ITF.')
      end
    end

    it 'should create the sidekick job' do
      VCR.use_cassette('evss/intent_to_file/active_compensation_future_date') do
        klass = EVSS::DisabilityCompensationForm::ServiceAllClaim
        expect_any_instance_of(klass).to receive(:validate_form526).and_return(true)
        expect(ClaimsApi::ClaimEstablisher).to receive(:perform_async)
        post path, params: data, headers: headers
      end
    end

    it 'should build the auth headers' do
      VCR.use_cassette('evss/intent_to_file/active_compensation_future_date') do
        auth_header_stub = instance_double('EVSS::DisabilityCompensationAuthHeaders')
        expect(EVSS::DisabilityCompensationAuthHeaders).to receive(:new) { auth_header_stub }
        expect(auth_header_stub).to receive(:add_headers)
        post path, params: data, headers: headers
      end
    end

    context 'with the same request already ran' do
      let!(:count) do
        post path, params: data, headers: headers
        ClaimsApi::AutoEstablishedClaim.count
      end

      it 'should reject the duplicated request' do
        post path, params: data, headers: headers
        expect(count).to eq(ClaimsApi::AutoEstablishedClaim.count)
      end
    end

    context 'validation' do
      let(:json_data) { JSON.parse data }

      it 'should require currentMailingAddress subfields' do
        params = json_data
        params['data']['attributes']['veteran']['currentMailingAddress'] = {}
        post path, params: params.to_json, headers: headers
        expect(response.status).to eq(422)
        expect(JSON.parse(response.body)['errors'].size).to eq(6)
      end

      it 'should require disability subfields' do
        params = json_data
        params['data']['attributes']['disabilities'] = [{}]
        post path, params: params.to_json, headers: headers
        expect(response.status).to eq(422)
        expect(JSON.parse(response.body)['errors'].size).to eq(2)
      end
    end

    context 'form 526 validation' do
      it 'should return a successful response when valid' do
        VCR.use_cassette('evss/disability_compensation_form/form_526_valid_validation') do
          post '/services/claims/v0/forms/526/validate', params: data, headers: headers
          parsed = JSON.parse(response.body)
          expect(parsed['data']['type']).to eq('claims_api_auto_established_claim_validation')
          expect(parsed['data']['attributes']['status']).to eq('valid')
        end
      end

      it 'should return a list of errors when invalid hitting EVSS' do
        VCR.use_cassette('evss/disability_compensation_form/form_526_invalid_validation') do
          post '/services/claims/v0/forms/526/validate', params: data, headers: headers
          parsed = JSON.parse(response.body)
          expect(response.status).to eq(422)
          expect(parsed['errors'].size).to eq(2)
        end
      end

      it 'should return a list of errors when invalid via internal validation' do
        json_data = JSON.parse data
        params = json_data
        params['data']['attributes']['veteran']['currentMailingAddress'] = {}
        post '/services/claims/v0/forms/526/validate', params: params.to_json, headers: headers
        parsed = JSON.parse(response.body)
        expect(response.status).to eq(422)
        expect(parsed['errors'].size).to eq(6)
      end
    end
  end

  describe '#upload_supporting_documents' do
    let(:auto_claim) { create(:auto_established_claim) }
    let(:params) do
      { 'attachment': Rack::Test::UploadedFile.new("#{::Rails.root}/modules/claims_api/spec/fixtures/extras.pdf") }
    end

    it 'should increase the supporting document count' do
      allow_any_instance_of(ClaimsApi::SupportingDocumentUploader).to receive(:store!)
      count = auto_claim.supporting_documents.count
      post "/services/claims/v0/forms/526/#{auto_claim.id}/attachments", params: params, headers: headers
      auto_claim.reload
      expect(auto_claim.supporting_documents.count).to eq(count + 1)
    end
  end
end
