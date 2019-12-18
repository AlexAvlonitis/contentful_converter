# frozen_string_literal: true

require 'contentful_converter/nodes/base'

module ContentfulConverter
  module Nodes
    class OrderedList < Base
      def needs_p_wrapping?
        false
      end

      def add_content(node)
        return unless node.class == Nodes::ListItem

        super
      end

      private

      def type
        'ordered-list'
      end
    end
  end
end
