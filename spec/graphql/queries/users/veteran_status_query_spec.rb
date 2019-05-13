# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::Users::VeteranStatusQuery do
  let(:user) { build(:user, :loa3) }
  let(:query) do
    <<-GRAPHQL
      query {
        userVeteranStatus {
          veteranStatus {
            status
            isVeteran
            servedInMilitary
          }
          errors {
            externalService
            startTime
            endTime
            description
            status
          }
        }
      }
    GRAPHQL
  end

  let(:response) { VetsAPISchema.execute(query, context: { current_user: user }) }
  let(:results) { response.dig('data', 'userVeteranStatus', 'veteranStatus') }

  it 'returns a status of OK' do
    expect(results['status']).to eq 'OK'
  end

  it 'returns the expected veteran status data', :aggregate_failures do
    expect(results['isVeteran']).to eq user.veteran?
    expect(results['servedInMilitary']).to eq user.served_in_military?
  end

  it 'returns no errors' do
    expect(response.dig('data', 'userVeteranStatus', 'errors')).to be_nil
  end

  context 'with a non-OK status' do
    before(:each) do
      allow_any_instance_of(
        EMISRedis::VeteranStatus
      ).to receive(:veteran?).and_raise(EMISRedis::VeteranStatus::RecordNotFound.new(status: 404))
    end

    let(:response) { VetsAPISchema.execute(query, context: { current_user: user }) }
    let(:results) { response.dig('data', 'userVeteranStatus', 'veteranStatus') }

    it 'returns error details', :aggregate_failures do
      error = response.dig('data', 'userVeteranStatus', 'errors')

      expect(error.dig('status')).to eq '404'
      expect(error.dig('externalService')).to eq 'EMIS'
      expect(error.dig('startTime')).to be_present
      expect(error.dig('endTime')).to be_nil
      expect(error.dig('description')).to include 'NOT_FOUND'
    end

    it 'sets all of the veteran status fields to nil', :aggregate_failures do
      expect(results['status']).to be_nil
      expect(results['isVeteran']).to be_nil
      expect(results['servedInMilitary']).to be_nil
    end
  end
end
