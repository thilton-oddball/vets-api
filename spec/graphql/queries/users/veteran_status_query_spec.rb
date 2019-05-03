# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::Users::VeteranStatusQuery do
  let(:user) { build(:user, :loa3) }
  let(:query) do
    <<-GRAPHQL
      query {
        userVeteranStatus {
          status
          isVeteran
          servedInMilitary
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
  let(:results) { response.dig('data', 'userVeteranStatus') }

  it 'returns a status of OK' do
    expect(results['status']).to eq 'OK'
  end

  it 'returns the expected veteran status data', :aggregate_failures do
    expect(results['isVeteran']).to eq user.veteran?
    expect(results['servedInMilitary']).to eq user.served_in_military?
  end

  it 'returns no errors' do
    expect(results.dig('errors')).to be_nil
  end

  context 'with a non-OK status' do
    before(:each) do
      allow_any_instance_of(
        EMISRedis::VeteranStatus
      ).to receive(:veteran?).and_raise(EMISRedis::VeteranStatus::RecordNotFound.new(status: 404))
    end

    let(:response) { VetsAPISchema.execute(query, context: { current_user: user }) }
    let(:results) { response.dig('data', 'userVeteranStatus') }

    it 'returns error details', :aggregate_failures do
      errors = results.dig('errors')

      expect(errors.dig('status')).to eq '404'
      expect(errors.dig('externalService')).to eq 'EMIS'
      expect(errors.dig('startTime')).to be_present
      expect(errors.dig('endTime')).to be_nil
      expect(errors.dig('description')).to include 'NOT_FOUND'
    end

    it 'sets all of the veteran status fields to nil', :aggregate_failures do
      expect(results['status']).to be_nil
      expect(results['isVeteran']).to be_nil
      expect(results['servedInMilitary']).to be_nil
    end
  end
end
