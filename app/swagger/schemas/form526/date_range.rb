# frozen_string_literal: true

module Swagger
  module Schemas
    module Form526
      class DateRange
        include Swagger::Blocks

        date_pattern = Regexp.new(Swagger::Schemas::Form526::Form526SubmitV2::DATE_PATTERN).to_js
        
        swagger_schema :DateRange do
          property :from,
                   type: :string,
                   pattern: date_pattern,
                   example: '2019-10-XX'
          property :to,
                   type: :string,
                   pattern: date_pattern,
                   example: 'XXXX-12-31'
        end

        swagger_schema :DateRangeAllRequired do
          key :required, %i[to from]

          property :from,
                   type: :string,
                   pattern: date_pattern,
                   example: '2019-10-XX'
          property :to,
                   type: :string,
                   pattern: date_pattern,
                   example: 'XXXX-12-31'
        end

        swagger_schema :DateRangeFromRequired do
          key :required, [:from]

          property :from,
                   type: :string,
                   pattern: date_pattern,
                   example: '2019-10-XX'
          property :to,
                   type: :string,
                   pattern: date_pattern,
                   example: 'XXXX-12-31'
        end
      end
    end
  end
end
