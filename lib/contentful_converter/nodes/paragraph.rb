# frozen_string_literal: true

require 'contentful_converter/nodes/base'

module ContentfulConverter
  module Nodes
    class Paragraph < Base
      def needs_p_wrapping?
        false
      end

      def to_h(params = {})
        super
        return nil if params[:content].empty?

        params
      end

      private

      def type
        'paragraph'
      end
    end
  end
end
