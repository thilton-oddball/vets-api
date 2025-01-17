# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VBA Documents Metadata Endpoint', type: :request do
  describe '#get /metadata' do
    it 'should return metadata JSON' do
      get '/services/vba_documents/metadata'
      expect(response).to have_http_status(:ok)
      JSON.parse(response.body)
    end
  end

  context 'healthchecks' do
    context 'V0' do
      it 'should return correct response and status when healthy' do
        get '/services/vba_documents/v0/healthcheck'
        parsed_response = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(parsed_response['data']['attributes']['healthy']).to eq(true)
      end

      it 'should return correct status when not healthy' do
        allow(CentralMail::Service).to receive(:current_breaker_outage?).and_return(true)
        get '/services/vba_documents/v0/healthcheck'
        expect(response.status).to eq(503)
      end
    end

    context 'V1' do
      it 'should return correct response and status when healthy' do
        get '/services/vba_documents/v1/healthcheck'
        parsed_response = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(parsed_response['data']['attributes']['healthy']).to eq(true)
      end

      it 'should return correct status when not healthy' do
        allow(CentralMail::Service).to receive(:current_breaker_outage?).and_return(true)
        get '/services/vba_documents/v1/healthcheck'
        expect(response.status).to eq(503)
      end
    end
  end
end
