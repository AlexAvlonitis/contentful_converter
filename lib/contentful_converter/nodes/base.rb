# frozen_string_literal: true

module ContentfulConverter
  module Nodes
    class Base
      attr_reader :node_type, :content, :nokogiri_node, :parent

      def initialize(nokogiri_node = nil, parent = nil)
        @nokogiri_node = nokogiri_node
        @parent = parent
        @node_type = type
        @content = []
      end

      def add_content(node)
        @content << node
      end

      def to_h(params = {})
        params[:nodeType] = node_type
        params[:data]     = params[:data] || {}
        params[:content]  = content.map(&:to_h).compact
        params
      end

      def needs_p_wrapping?
        if parent.nil? ||
            parent&.class == Nodes::Header ||
            parent&.class == Nodes::Paragraph ||
            parent&.class == Nodes::Hyperlink

          return false
        end

        true
      end

      private

      def value
        nokogiri_node.content
      end

      def type
        raise NotImplementedError
      end

      def options
        raise NotImplementedError
      end
    end
  end
end
