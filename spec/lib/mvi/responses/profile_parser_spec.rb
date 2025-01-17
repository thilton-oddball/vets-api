# frozen_string_literal: true

require 'rails_helper'
require 'mvi/responses/profile_parser'

describe MVI::Responses::ProfileParser do
  let(:faraday_response) { instance_double('Faraday::Response') }
  let(:parser) { MVI::Responses::ProfileParser.new(faraday_response) }

  context 'given a valid response' do
    let(:body) { Ox.parse(File.read('spec/support/mvi/find_candidate_response.xml')) }

    before(:each) do
      allow(faraday_response).to receive(:body) { body }
    end

    describe '#failed_or_invalid?' do
      it 'should return false' do
        expect(parser.failed_or_invalid?).to be_falsey
      end
    end

    describe '#parse' do
      let(:mvi_profile) do
        build(
          :mvi_profile_response,
          :address_austin,
          birls_id: nil,
          sec_id: nil,
          historical_icns: nil
        )
      end
      it 'returns a MviProfile with the parsed attributes' do
        expect(parser.parse).to have_deep_attributes(mvi_profile)
      end

      context 'when name parsing fails' do
        let(:mvi_profile) do
          build(
            :mvi_profile_response,
            :address_austin,
            family_name: nil,
            given_names: nil,
            suffix: nil,
            birls_id: nil,
            sec_id: nil,
            historical_icns: nil
          )
        end
        it 'should set the names to false' do
          allow(parser).to receive(:get_patient_name).and_return(nil)
          expect(parser.parse).to have_deep_attributes(mvi_profile)
        end
      end

      context 'with a missing address, invalid edipi, and invalid participant id' do
        let(:body) { Ox.parse(File.read('spec/support/mvi/find_candidate_response_nil_address.xml')) }
        let(:mvi_profile) do
          build(
            :mvi_profile_response,
            address: nil,
            birls_id: nil,
            sec_id: nil,
            historical_icns: nil,
            vet360_id: nil,
            edipi: nil,
            participant_id: nil,
            full_mvi_ids: [
              '1000123456V123456^NI^200M^USVHA^P',
              '12345^PI^516^USVHA^PCE',
              '2^PI^553^USVHA^PCE',
              '12345^PI^200HD^USVHA^A',
              'TKIP123456^PI^200IP^USVHA^A',
              '123456^PI^200MHV^USVHA^A',
              'UNK^NI^200DOD^USDOD^A',
              'UNK^PI^200CORP^USVBA^A'
            ]
          )
        end
        it 'should set the address to nil' do
          expect(parser.parse).to have_deep_attributes(mvi_profile)
        end
      end

      context 'with no middle name, missing and alternate correlation ids, multiple other_ids' do
        let(:icn_with_aaid) { '1008714701V416111^NI^200M^USVHA' }
        let(:body) { Ox.parse(File.read('spec/support/mvi/find_candidate_missing_attrs.xml')) }
        let(:mvi_profile) do
          build(
            :mvi_profile_response,
            :missing_attrs,
            :address_austin,
            sec_id: nil,
            historical_icns: nil,
            mhv_ids: ['1100792239'],
            active_mhv_ids: ['1100792239'],
            icn_with_aaid: icn_with_aaid,
            full_mvi_ids: [
              '1008714701V416111^NI^200M^USVHA^P',
              '796122306^PI^200BRLS^USVBA^A',
              '9100792239^PI^200CORP^USVBA^A',
              '1100792239^PI^200MHS^USVHA^A'
            ]
          )
        end
        it 'should filter with only first name and retrieve correct MHV id' do
          expect(parser.parse).to have_deep_attributes(mvi_profile)
        end
      end
    end
  end

  context 'with no subject element' do
    let(:body) { Ox.parse(File.read('spec/support/mvi/find_candidate_no_subject.xml')) }
    let(:mvi_profile) { build(:mvi_profile_response, :missing_attrs) }

    describe '#parse' do
      it 'return nil if the response includes no suject element' do
        allow(faraday_response).to receive(:body) { body }
        expect(parser.parse).to be_nil
      end
    end
  end

  context 'given an invalid response' do
    let(:body) { Ox.parse(File.read('spec/support/mvi/find_candidate_invalid_response.xml')) }

    describe '#failed_or_invalid?' do
      it 'should return true' do
        allow(faraday_response).to receive(:body) { body }
        expect(parser.failed_or_invalid?).to be_truthy
      end
    end
  end

  context 'given a failure response' do
    let(:body) { Ox.parse(File.read('spec/support/mvi/find_candidate_failure_response.xml')) }

    describe '#failed_or_invalid?' do
      it 'should return true' do
        allow(faraday_response).to receive(:body) { body }
        expect(parser.failed_or_invalid?).to be_truthy
      end
    end
  end

  context 'given a multiple match' do
    let(:body) { Ox.parse(File.read('spec/support/mvi/find_candidate_multiple_match_response.xml')) }

    before(:each) do
      allow(faraday_response).to receive(:body) { body }
    end

    describe '#failed_or_invalid?' do
      it 'should return false' do
        expect(parser.failed_or_invalid?).to be_truthy
      end
    end

    describe '#multiple_match?' do
      it 'should return true' do
        expect(parser.multiple_match?).to be_truthy
      end
    end
  end

  context 'with multiple MHV IDs' do
    let(:icn_with_aaid) { '12345678901234567^NI^200M^USVHA' }
    let(:body) { Ox.parse(File.read('spec/support/mvi/find_candidate_multiple_mhv_response.xml')) }
    let(:mvi_profile) do
      build(
        :mvi_profile_response,
        :multiple_mhvids,
        historical_icns: nil,
        icn_with_aaid: icn_with_aaid,
        full_mvi_ids: [
          '12345678901234567^NI^200M^USVHA^P',
          '12345678^PI^200CORP^USVBA^A',
          '12345678901^PI^200MH^USVHA^A',
          '12345678902^PI^200MH^USVHA^D',
          '1122334455^NI^200DOD^USDOD^A',
          '0001234567^PN^200PROV^USDVA^A',
          '123412345^PI^200BRLS^USVBA^A'
        ]
      )
    end

    before(:each) do
      allow(faraday_response).to receive(:body) { body }
    end

    it 'returns an array of mhv ids' do
      expect(parser.parse).to have_deep_attributes(mvi_profile)
    end
  end

  context 'with a vet360 id' do
    let(:body) { Ox.parse(File.read('spec/support/mvi/find_candidate_response.xml')) }
    let(:mvi_profile) do
      build(
        :mvi_profile_response,
        :address_austin,
        historical_icns: nil,
        birls_id: nil,
        sec_id: nil
      )
    end

    before(:each) do
      allow(faraday_response).to receive(:body) { body }
    end

    it 'correctly parses a Vet360 ID' do
      expect(parser.parse).to have_deep_attributes(mvi_profile)
    end
  end

  context 'with inactive MHV ID edge cases' do
    let(:body) { Ox.parse(File.read('spec/support/mvi/find_candidate_inactive_mhv_ids.xml')) }

    before { Settings.sentry.dsn = 'asdf' }
    after { Settings.sentry.dsn = nil }

    before(:each) do
      allow(faraday_response).to receive(:body) { body }
    end

    it 'logs warning about inactive IDs' do
      msg1 = 'Inactive MHV correlation IDs present'
      msg2 = 'Returning inactive MHV correlation ID as first identifier'
      expect(Raven).to receive(:extra_context).with(ids: %w[12345678901 12345678902]).twice
      expect(Raven).to receive(:capture_message).with(msg1, level: 'info')
      expect(Raven).to receive(:capture_message).with(msg2, level: 'warning')
      parser.parse
    end
  end
end
