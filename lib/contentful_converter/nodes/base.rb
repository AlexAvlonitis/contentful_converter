# frozen_string_literal: true

module ContentfulConverter
  module Nodes
    class Base
      attr_reader :nodeType, :content, :nokogiri_node

      def initialize(nokogiri_node = nil)
        @nokogiri_node = nokogiri_node
        @nodeType = type
        @content = []
      end

      def add_content(node)
        @content << node
      end

      def to_h(params = {})
        params[:nodeType] = nodeType
        params[:data]     = params[:data] || {}
        params[:content]  = content.map(&:to_h).compact
        params
      end

      private

      def value
        nokogiri_node.content
      end

      def type
        raise NotImplementedError
      end
    end
  end
end
