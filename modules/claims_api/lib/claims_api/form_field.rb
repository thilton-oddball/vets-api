# frozen_string_literal: true

module ClaimsApi
  class FormField
    attr_accessor :key, :required

    def initialize(key:, required:)
      @key = key
      @required = required
    end
  end
end
