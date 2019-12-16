# frozen_string_literal: true

require 'contentful_converter/nodes/base'

module ContentfulConverter
  module Nodes
    class Text < Base
      def to_h(params = options)
        return nil if value.strip.empty?

        super
        params.delete(:content)
        params
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
