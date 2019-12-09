# frozen_string_literal: true

require 'contentful_converter/nodes/base'

module ContentfulConverter
  module Nodes
    class Hyperlink < Base
      def to_h(params = options)
        super
      end

      private

      def type
        'hyperlink'
      end

      def options
        { data: { uri: nokogiri_node.attributes['href'].value } }
      end
    end
  end
end
