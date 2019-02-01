# frozen_string_literal: true

module Common
  module Exceptions
    # Base error class all others inherit from
    class BaseError < StandardError
      def errors
        raise NotImplementedError, 'Subclass of Error must implement errors method'
      end

      def status_code
        errors&.first&.status&.to_i
      end

      def message
        "#{interpolated[:title]}: #{interpolated[:detail]} (#{i18n_data[:code]})"
      end

      def errors
        Array(SerializableError.new(interpolated))
      end

      private

      def interpolated
        i18n_interpolated
      end

      def i18n_key
        "common.exceptions.#{self.class.name.split('::').last.underscore}"
      end

      def i18n_data
        I18n.t(i18n_key)
      end

      def i18n_field(attribute, options)
        I18n.t("#{i18n_key}.#{attribute}", options)
      rescue
        nil
      end

      def i18n_interpolated(options = {})
        merge_values = Hash[options.map { |attribute, opts| [attribute, i18n_field(attribute, opts)] }]
        i18n_data.merge(merge_values)
      end
    end
  end
end
