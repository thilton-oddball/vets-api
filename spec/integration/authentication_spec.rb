# frozen_string_literal: true

require 'integration_helper'
require 'pry'

[:chrome, :firefox, :safari].each do |browser| # , :ie, :edge
  describe "#{browser} " do
    describe 'id.me ' do
      before(:all) do
        @browser = Watir::Browser.new browser
      end

      after(:all) do
        begin
          @browser.kill!
        rescue StandardError
          nil
        end
      end

      it 'signs in with id.me' do
        id_me_class = 'va-button-primary'
        user_attributes = log_in_as('anna@adhoc.team', '3264u49x3qkxG9', id_me_class)
        expect(user_attributes['profile']['loa']['current']).to eq(1)
        expect(user_attributes['profile']['loa']['highest']).to eq(1)
        expect(user_attributes['profile']['email']).to eq('anna@adhoc.team')
        expect(user_attributes['profile']['authn_context']).to eq(nil)
      end

      def log_in_as(user, password, type)
        @browser.goto 'staging.va.gov'

        #temporary, until full-screen login is default
        @browser.execute_script("localStorage.setItem('enableFullScreenLogin', true);")

        @browser.button(class: 'va-modal-close').click
        @browser.button(class: 'sign-in-link').click
        @browser.button(class: type).click # dslogon, mhv, va-button-primary, idme-create
        @browser.text_field(id: 'user_email').set user
        @browser.text_field(id: 'user_password').set password
        @browser.button(name: 'commit').click
        @browser.span(class: 'user-dropdown-email')
        expect(@browser.span(class: 'user-dropdown-email').wait_until(&:present?).text).to eq(user)
        @browser.goto 'staging-api.va.gov/v0/user'
        JSON.parse(@browser.body.text)['data']['attributes']
      end
    end
  end
end
