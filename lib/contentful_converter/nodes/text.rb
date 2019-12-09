# frozen_string_literal: true

require 'contentful_converter/nodes/base'

module ContentfulConverter
  module Nodes
    class Text < Base
      def to_h(hash = options)
        super
      end

      private

      def type
        'text'
      end

      def options
        {
          value: value,
          marks: marks.map { |mark| { type: mark } }
        }
      end

      def marks
        []
      end
    end
  end
end
