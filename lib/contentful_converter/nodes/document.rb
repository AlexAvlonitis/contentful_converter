# frozen_string_literal: true

require 'contentful_converter/nodes/base'

module ContentfulConverter
  module Nodes
    class Document < Base
      private

      def type
        'document'
      end
    end
  end
end
