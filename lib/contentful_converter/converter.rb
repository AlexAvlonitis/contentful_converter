# frozen_string_literal: true

require 'nokogiri'
require 'contentful_converter/tree_cloner'

module ContentfulConverter
  class Converter
    class << self
      def convert(html)
        raise_error_unless_string(html)

        convert_to_rich_text(nokogiri_fragment(html))
      end

      private

      def raise_error_unless_string(param)
        return if param.is_a?(String)

        raise ArgumentError, 'Converter param needs to be a string'
      end

      def convert_to_rich_text(nokogiri_fragment)
        TreeCloner.nokogiri_to_rich_text(nokogiri_fragment)
      end

      def nokogiri_fragment(html)
        Nokogiri::HTML.fragment(sanitize(html))
      end

      def sanitize(html)
        html = html.dup
        html.gsub!('div>', 'p>')
        html.gsub!('section>', 'p>')
        html
      end
    end
  end
end
