# frozen_string_literal: true

require 'rails_helper'

describe Gibft::Service, type: :model do
  let(:service) { described_class.new }
  let(:client) { double }

  describe '#submit' do
    before do
      VCR.config do |c|
        c.allow_http_connections_when_no_cassette = true
      end
      gi_bill_feedback = FactoryBot.create(
        :gi_bill_feedback,
        form: {  
           "issue":{  
              "other":false,
              "recruiting":false,
              "studentLoans":true,
              "quality":false,
              "creditTransfer":false,
              "accreditation":false,
              "jobOpportunities":false,
              "gradePolicy":false,
              "refundIssues":false,
              "financialIssues":false,
              "changeInDegree":false,
              "transcriptRelease":false
           },
           "issueDescription":"f",
           "issueResolution":"s",
           "educationDetails":{  
              "school":{  
                 "name":"ABO AKADEMI UNIVERSITY",
                 "address":{  
                    "country":"United States",
                    "street":"FILTERED",
                    "city":"FILTERED"
                 }
              },
              "programs":{  
                 "Post-9/11 Ch 33":false,
                 "MGIB-AD Ch 30":false,
                 "MGIB-SR Ch 1606":false,
                 "TATU":false,
                 "REAP":false,
                 "DEA Ch 35":true,
                 "VRE Ch 31":false
              },
              "assistance":{  
                 "TA":false,
                 "TA-AGR":false,
                 "MyCAA":true,
                 "FFA":false
              }
           },
           "onBehalfOf":"Anonymous",
           "privacyAgreementAccepted":true
        }.to_json
      )
      user = create(:evss_user)
      binding.pry; fail
      # gi_bill_feedback.user = user
      res = Gibft::Service.new.submit(gi_bill_feedback.transform_form)

      binding.pry; fail
      expect(service).to receive(:get_oauth_token).and_return('token')

      expect(Restforce).to receive(:new).with(
        oauth_token: 'token',
        instance_url: Gibft::Configuration::SALESFORCE_INSTANCE_URL,
        api_version: '41.0'
      ).and_return(client)
      expect(client).to receive(:post).with(
        '/services/apexrest/educationcomplaint', {}
      ).and_return(
        OpenStruct.new(
          body: {
            'case_id' => 'case_id',
            'case_number' => 'case_number'
          }
        )
      )
    end

    it 'should submit the form' do
      expect(service.submit({})).to eq('case_id' => 'case_id', 'case_number' => 'case_number')
    end
  end
end
