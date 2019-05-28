# frozen_string_literal: true

module Swagger
  module Schemas
    module Vet360
      class Address
        include Swagger::Blocks
        ALPHA_REGEX = Regexp.new(::Vet360::Models::Address::VALID_ALPHA_REGEX.inspect).to_js
        NUMERIC_REGEX = Regexp.new(::Vet360::Models::Address::VALID_NUMERIC_REGEX.inspect).to_js

        swagger_schema :PostVet360DomesticAddress do
          key :required, %i[
            address_line1
            address_pou
            address_type
            city
            country_name
            state_code
            zip_code
          ]
          property :address_line1,
                   type: :string,
                   example: '1493 Martin Luther King Rd',
                   maxLength: 100
          property :address_line2, type: :string, maxLength: 100
          property :address_line3, type: :string, maxLength: 100
          property :address_pou,
                   type: :string,
                   enum: ::Vet360::Models::Address::ADDRESS_POUS,
                   example: ::Vet360::Models::Address::RESIDENCE
          property :address_type,
                   type: :string,
                   enum: ::Vet360::Models::Address::ADDRESS_TYPES,
                   example: ::Vet360::Models::Address::DOMESTIC
          property :city, type: :string, example: 'Fulton', maxLength: 100
          property :country_name,
                   type: :string,
                   example: 'United States',
                   pattern: ALPHA_REGEX
          property :state_code,
                   type: :string,
                   example: 'MS',
                   minLength: 2,
                   maxLength: 2,
                   pattern: ALPHA_REGEX
          property :zip_code,
                   type: :string,
                   example: '38843',
                   maxLength: 5,
                   pattern: NUMERIC_REGEX
        end

        swagger_schema :PutVet360DomesticAddress do
          key :required, %i[
            address_line1
            address_pou
            address_type
            city
            country_name
            id
            state_code
            zip_code
          ]
          property :id, type: :integer, example: 1
          property :address_line1,
                   type: :string,
                   example: '1493 Martin Luther King Rd',
                   maxLength: 100
          property :address_line2, type: :string, maxLength: 100
          property :address_line3, type: :string, maxLength: 100
          property :address_pou,
                   type: :string,
                   enum: ::Vet360::Models::Address::ADDRESS_POUS,
                   example: ::Vet360::Models::Address::RESIDENCE
          property :address_type,
                   type: :string,
                   enum: ::Vet360::Models::Address::ADDRESS_TYPES,
                   example: ::Vet360::Models::Address::DOMESTIC
          property :city, type: :string, example: 'Fulton', maxLength: 100
          property :country_name,
                   type: :string,
                   example: 'United States',
                   pattern: ALPHA_REGEX
          property :state_code,
                   type: :string,
                   example: 'MS',
                   minLength: 2,
                   maxLength: 2,
                   pattern: ALPHA_REGEX
          property :zip_code,
                   type: :string,
                   example: '38843',
                   maxLength: 5,
                   pattern: NUMERIC_REGEX
        end

        swagger_schema :PostVet360InternationalAddress do
          key :required, %i[
            address_line1
            address_pou
            address_type
            international_postal_code
            city
            country_name
          ]
          property :address_line1,
                   type: :string,
                   example: '1493 Martin Luther King Rd',
                   maxLength: 100
          property :address_line2, type: :string, maxLength: 100
          property :address_line3, type: :string, maxLength: 100
          property :address_pou,
                   type: :string,
                   enum: ::Vet360::Models::Address::ADDRESS_POUS,
                   example: ::Vet360::Models::Address::RESIDENCE
          property :address_type,
                   type: :string,
                   enum: ::Vet360::Models::Address::ADDRESS_TYPES,
                   example: ::Vet360::Models::Address::INTERNATIONAL
          property :city, type: :string, example: 'Florence', maxLength: 100
          property :country_name,
                   type: :string,
                   example: 'Italy',
                   pattern: ALPHA_REGEX
          property :international_postal_code, type: :string, example: '12345'
        end

        swagger_schema :PutVet360InternationalAddress do
          key :required, %i[
            address_line1
            address_pou
            address_type
            id
            international_postal_code
            city
            country_name
          ]
          property :id, type: :integer, example: 1
          property :address_line1,
                   type: :string,
                   example: '1493 Martin Luther King Rd',
                   maxLength: 100
          property :address_line2, type: :string, maxLength: 100
          property :address_line3, type: :string, maxLength: 100
          property :address_pou,
                   type: :string,
                   enum: ::Vet360::Models::Address::ADDRESS_POUS,
                   example: ::Vet360::Models::Address::RESIDENCE
          property :address_type,
                   type: :string,
                   enum: ::Vet360::Models::Address::ADDRESS_TYPES,
                   example: ::Vet360::Models::Address::INTERNATIONAL
          property :city, type: :string, example: 'Florence', maxLength: 100
          property :country_name,
                   type: :string,
                   example: 'Italy',
                   pattern: ALPHA_REGEX
          property :international_postal_code, type: :string, example: '12345'
        end

        swagger_schema :PostVet360MilitaryOverseasAddress do
          key :required, %i[
            address_line1
            address_pou
            address_type
            city
            country_name
            state_code
            zip_code
          ]
          property :address_line1,
                   type: :string,
                   example: '1493 Martin Luther King Rd',
                   maxLength: 100
          property :address_line2, type: :string, maxLength: 100
          property :address_line3, type: :string, maxLength: 100
          property :address_pou,
                   type: :string,
                   enum: ::Vet360::Models::Address::ADDRESS_POUS,
                   example: ::Vet360::Models::Address::RESIDENCE
          property :address_type,
                   type: :string,
                   enum: ::Vet360::Models::Address::ADDRESS_TYPES,
                   example: ::Vet360::Models::Address::MILITARY
          property :city, type: :string, example: 'Fulton', maxLength: 100
          property :country_name,
                   type: :string,
                   example: 'United States',
                   pattern: ALPHA_REGEX
          property :state_code,
                   type: :string,
                   example: 'MS',
                   minLength: 2,
                   maxLength: 2,
                   pattern: ALPHA_REGEX
          property :zip_code,
                   type: :string,
                   example: '38843',
                   maxLength: 5,
                   pattern: NUMERIC_REGEX
        end

        swagger_schema :PutVet360MilitaryOverseasAddress do
          key :required, %i[
            address_line1
            address_pou
            address_type
            city
            country_name
            id
            state_code
            zip_code
          ]
          property :id, type: :integer, example: 1
          property :address_line1,
                   type: :string,
                   example: '1493 Martin Luther King Rd',
                   maxLength: 100
          property :address_line2, type: :string, maxLength: 100
          property :address_line3, type: :string, maxLength: 100
          property :address_pou,
                   type: :string,
                   enum: ::Vet360::Models::Address::ADDRESS_POUS,
                   example: ::Vet360::Models::Address::RESIDENCE
          property :address_type,
                   type: :string,
                   enum: ::Vet360::Models::Address::ADDRESS_TYPES,
                   example: ::Vet360::Models::Address::MILITARY
          property :city, type: :string, example: 'Fulton', maxLength: 100
          property :country_name,
                   type: :string,
                   example: 'United States',
                   pattern: ALPHA_REGEX
          property :state_code,
                   type: :string,
                   example: 'MS',
                   minLength: 2,
                   maxLength: 2,
                   pattern: ALPHA_REGEX
          property :zip_code,
                   type: :string,
                   example: '38843',
                   maxLength: 5,
                   pattern: NUMERIC_REGEX
        end
      end
    end
  end
end
