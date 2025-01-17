# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VA Facilities Documentation Endpoint', type: :request do
  describe '#get /docs/v0/api' do
    it 'should return Open API Spec v3 JSON' do
      get '/services/va_facilities/docs/v0/api'
      expect(response).to have_http_status(:ok)
      JSON.parse(response.body)
    end
  end

  describe '#get /docs/v1/api' do
    it 'should return Open API Spec v3 JSON' do
      get '/services/va_facilities/docs/v1/api'
      expect(response).to have_http_status(:ok)
      JSON.parse(response.body)
    end
  end
end
