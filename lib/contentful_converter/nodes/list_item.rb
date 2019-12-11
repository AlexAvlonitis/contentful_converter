# frozen_string_literal: true

require 'contentful_converter/nodes/base'

module ContentfulConverter
  module Nodes
    class ListItem < Base
      private

      def type
        'list-item'
      end
    end
  end
end
