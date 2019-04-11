# frozen_string_literal: true

module ClaimsApi
  module FormValidatable
    extend ActiveSupport::Concern

    FORM_FIELDS ||= [].freeze

    included do
      self::FORM_FIELDS.each do |field|
        root = field::ROOT
        attr_accessor root.key

        validates root.key, prescense: true if root.required
      end
      binding.pry
    end

    def ensure_fields
      raise 'must implement FORM_FIELDS' if self.class::FORM_FIELDS.size.zero?
    end

    def to_permittable
      ensure_fields
      binding.pry
    end
  end
end
