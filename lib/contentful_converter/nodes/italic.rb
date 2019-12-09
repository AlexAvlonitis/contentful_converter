# frozen_string_literal: true

require 'contentful_converter/nodes/text'

module ContentfulConverter
  module Nodes
    class Italic < Text
      def marks
        ['italic']
      end
    end
  end
end
