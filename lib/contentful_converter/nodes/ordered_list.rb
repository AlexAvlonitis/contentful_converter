# frozen_string_literal: true

require 'contentful_converter/nodes/base'

module ContentfulConverter
  module Nodes
    class OrderedList < Base
      private

      def type
        'ordered-list'
      end
    end
  end
end
