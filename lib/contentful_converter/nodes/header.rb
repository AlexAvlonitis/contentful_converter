# frozen_string_literal: true

require 'contentful_converter/nodes/base'

module ContentfulConverter
  module Nodes
    class Header < Base
      private

      def type
        "header-#{header_size}"
      end

      def header_size
        nokogiri_node.name.split('h').last
      end
    end
  end
end
