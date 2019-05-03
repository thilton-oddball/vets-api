# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::Users::Vet360ContactInformationQuery do
  let(:user) { build(:user, :loa3) }

  context 'the email field' do
    let(:query) do
      <<-GRAPHQL
        query {
          userVet360ContactInformation {
            email {
              createdAt
              effectiveEndDate
              effectiveStartDate
              emailAddress
              id
              sourceDate
              transactionId
              updatedAt
              vet360Id
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
    let(:results) { response.dig('data', 'userVet360ContactInformation') }
    let(:fields) do
      %w[
        createdAt
        emailAddress
        id
        sourceDate
        transactionId
        updatedAt
        vet360Id
      ]
    end

    it 'returns the expected email data', :aggregate_failures do
      email = results.dig('email')

      fields.each do |field|
        expect(email[field]).to be_present
      end
    end

    it 'returns no errors' do
      expect(results.dig('errors')).to be_nil
    end
  end

  context 'an address field' do
    let(:query) do
      <<-GRAPHQL
        query {
          userVet360ContactInformation {
            residentialAddress {
              addressLine1
              addressLine2
              addressLine3
              addressPou
              addressType
              city
              countryName
              countryCodeIso2
              countryCodeIso3
              countyCode
              countyName
              createdAt
              effectiveEndDate
              effectiveStartDate
              id
              internationalPostalCode
              sourceDate
              stateCode
              transactionId
              updatedAt
              vet360Id
              zipCode
              zipCodeSuffix
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
    let(:results) { response.dig('data', 'userVet360ContactInformation') }
    let(:fields) do
      %w[
        addressLine1
        addressPou
        addressType
        city
        countryName
        countryCodeIso3
        createdAt
        id
        sourceDate
        stateCode
        transactionId
        updatedAt
        vet360Id
        zipCode
      ]
    end

    it 'returns the expected address data', :aggregate_failures do
      residential_address = results.dig('residentialAddress')

      fields.each do |field|
        expect(residential_address[field]).to be_present
      end
    end

    it 'returns no errors' do
      expect(results.dig('errors')).to be_nil
    end
  end

  context 'a phone field' do
    let(:query) do
      <<-GRAPHQL
        query {
          userVet360ContactInformation {
            mobilePhone {
              areaCode
              countryCode
              createdAt
              extension
              id
              isInternational
              isVoicemailable
              phoneNumber
              phoneType
              sourceDate
              transactionId
              isTty
              updatedAt
              vet360Id
              effectiveEndDate
              effectiveStartDate
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
    let(:results) { response.dig('data', 'userVet360ContactInformation') }
    let(:fields) do
      %w[
        areaCode
        countryCode
        createdAt
        id
        isInternational
        isVoicemailable
        phoneNumber
        phoneType
        sourceDate
        transactionId
        isTty
        updatedAt
        vet360Id
      ]
    end

    it 'returns the expected phone data', :aggregate_failures do
      mobile_phone = results.dig('mobilePhone')

      fields.each do |field|
        expect(mobile_phone[field]).to_not be_nil
      end
    end

    it 'returns no errors' do
      expect(results.dig('errors')).to be_nil
    end
  end

  context 'with all Vet360 fields' do
    let(:query) do
      <<-GRAPHQL
        query {
          userVet360ContactInformation {
            email {
              emailAddress
            }
            residentialAddress {
              addressLine1
            }
            mailingAddress {
              addressLine1
            }
            mobilePhone {
              phoneNumber
            }
            homePhone {
              phoneNumber
            }
            workPhone {
              phoneNumber
            }
            temporaryPhone {
              phoneNumber
            }
            faxNumber {
              phoneNumber
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
    let(:results) { response.dig('data', 'userVet360ContactInformation') }
    let(:fields) do
      %w[
        email
        residentialAddress
        mailingAddress
        mobilePhone
        homePhone
        workPhone
        temporaryPhone
        faxNumber
      ]
    end

    it 'returns the expected Vet360 data', :aggregate_failures do
      fields.each do |field|
        expect(results[field]).to be_present
      end
    end

    it 'returns no errors' do
      expect(results.dig('errors')).to be_nil
    end
  end

  context 'with an loa1 user' do
    let(:user) { build(:user, :loa1) }
    let(:query) do
      <<-GRAPHQL
        query {
          userVet360ContactInformation {
            email {
              emailAddress
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
    let(:results) { response.dig('data', 'userVet360ContactInformation') }

    it 'returns error details', :aggregate_failures do
      errors = results.dig('errors')

      expect(errors.dig('status')).to eq '400'
      expect(errors.dig('externalService')).to eq 'Vet360'
      expect(errors.dig('startTime')).to be_present
      expect(errors.dig('endTime')).to be_nil
      expect(errors.dig('description')).to include 'The Vet360 id could not be found'
    end

    it 'sets all of the requested email field to nil' do
      expect(results['email']).to be_nil
    end
  end

  context 'with an error' do
    let(:message) { 'the server responded with status 503' }
    let(:error_body) { { 'status' => 'some service unavailable status' } }
    let(:query) do
      <<-GRAPHQL
        query {
          userVet360ContactInformation {
            email {
              emailAddress
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

    before do
      allow_any_instance_of(User).to receive(:vet360_contact_info).and_raise(
        Common::Client::Errors::ClientError.new(message, 503, error_body)
      )
    end

    let(:response) { VetsAPISchema.execute(query, context: { current_user: user }) }
    let(:results) { response.dig('data', 'userVet360ContactInformation') }

    it 'returns error details', :aggregate_failures do
      errors = results.dig('errors')

      expect(errors.dig('status')).to eq '503'
      expect(errors.dig('externalService')).to eq 'Vet360'
      expect(errors.dig('startTime')).to be_present
      expect(errors.dig('endTime')).to be_nil
      expect(errors.dig('description')).to include 'Common::Client::Errors::ClientError'
    end

    it 'sets all of the requested email field to nil' do
      expect(results['email']).to be_nil
    end
  end
end
