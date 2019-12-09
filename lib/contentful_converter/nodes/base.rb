# frozen_string_literal: true

module ContentfulConverter
  module Nodes
    class Base
      attr_reader :nodeType, :data, :content, :nokogiri_node

      def initialize(nokogiri_node = nil)
        @nokogiri_node = nokogiri_node
        @nodeType = type
        @data = {}
        @content = []
      end

      def add_content(node)
        @content << node
      end

      def to_h(hash = {})
        hash[:nodeType] = nodeType
        hash[:data]     = data
        hash[:content]  = content.map(&:to_h).compact
        hash
      end

      private

      def value
        nokogiri_node.content
      end

      def type
        raise NotImplementedError, 'Needs to be instantiated from a child class'
      end
    end
  end
end
