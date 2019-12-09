# frozen_string_literal: true

require 'contentful_converter/nodes/base'

module ContentfulConverter
  module Nodes
    class Text < Base
      def to_h(hash = { marks: [], value: value })
        super
      end

      private

      def type
        'text'
      end
    end
  end
end
