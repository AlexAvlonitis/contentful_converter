# frozen_string_literal: true

require 'contentful_converter/nodes/text'

module ContentfulConverter
  module Nodes
    class Underline < Text
      def marks
        ['underline']
      end
    end
  end
end
