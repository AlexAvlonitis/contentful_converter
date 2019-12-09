# frozen_string_literal: true

require 'contentful_converter/nodes/base'

module ContentfulConverter
  module Nodes
    class Paragraph < Base
      private

      def type
        'paragraph'
      end
    end
  end
end
