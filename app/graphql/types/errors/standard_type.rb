# frozen_string_literal: true

module Types
  module Errors
    class StandardType < Types::BaseObject
      field :type, String, null: true
      field :message, String, null: true
    end
  end
end
