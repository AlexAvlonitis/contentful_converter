# frozen_string_literal: true

require 'contentful_converter/nodes/hyperlink'

module ContentfulConverter
  module Nodes
    class Embed < Hyperlink
      EMBED_VALUES = {
        asset: 'embedded-asset-block',
        entry: 'embedded-entry-block'
      }.freeze

      def needs_p_wrapping?
        false
      end

      private

      def type
        EMBED_VALUES[type_value.downcase.to_sym] || raise('Incorrect embed type')
      end

      def options
        hyperlink_entry_option(type_value.capitalize)
      end

      def type_value
        nokogiri_node[:type] || raise('Embed element requires a type')
      end

      def parsed_link
        nokogiri_node[:src]
      end
    end
  end
end
