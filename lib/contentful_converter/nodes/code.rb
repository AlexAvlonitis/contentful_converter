# frozen_string_literal: true

require 'contentful_converter/nodes/text'

module ContentfulConverter
  module Nodes
    class Code < Text
      def marks
        ['code']
      end
    end
  end
end
