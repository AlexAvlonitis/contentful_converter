# frozen_string_literal: true

require 'contentful_converter/nodes/base'

module ContentfulConverter
  module Nodes
    class Header < Base
      def needs_p_wrapping?
        false
      end

      private

      def type
        "heading-#{header_size}"
      end

      def header_size
        nokogiri_node.name.split('h').last
      end
    end
  end
end
