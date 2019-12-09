# frozen_string_literal: true

require 'nokogiri'
require 'contentful_converter/tree_cloner'
require 'pry'

module ContentfulConverter
  class Converter
    class << self
      def convert(html)
        raise_error_unless_string(html)

        nokogiri_fragment = Nokogiri::HTML.fragment(html)

        convert_to_rich_text(nokogiri_fragment)
      end

      private

      def raise_error_unless_string(param)
        return if param.is_a?(String)

        raise ArgumentError, 'Converter param needs to be a string'
      end

      def convert_to_rich_text(nokogiri_fragment)
        TreeCloner.clone_to_rich_text(nokogiri_fragment)
      end
    end
  end
end
