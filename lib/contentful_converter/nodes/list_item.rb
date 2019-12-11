# frozen_string_literal: true

require 'contentful_converter/nodes/base'

module ContentfulConverter
  module Nodes
    class ListItem < Base
      def needs_p_wrapping?
        false
      end

      private

      def type
        'list-item'
      end
    end
  end
end
