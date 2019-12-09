# frozen_string_literal: true

require 'contentful_converter/nodes/document'
require 'contentful_converter/nodes/header'
require 'contentful_converter/nodes/paragraph'
require 'contentful_converter/nodes/text'
require 'contentful_converter/nodes/underline'
require 'contentful_converter/nodes/italic'

module ContentfulConverter
  class NodeBuilder
    DEFAULT_MAPPINGS = {
      '#document-fragment' => Nodes::Document,
      'h1' => Nodes::Header,
      'h2' => Nodes::Header,
      'h3' => Nodes::Header,
      'h4' => Nodes::Header,
      'h5' => Nodes::Header,
      'h6' => Nodes::Header,
      'text' => Nodes::Text,
      'i' => Nodes::Italic,
      'u' => Nodes::Underline,
      'p' => Nodes::Paragraph,
      'div' => Nodes::Paragraph
    }.freeze

    class << self
      def build(nokogiri_node)
        rich_text_node = DEFAULT_MAPPINGS[nokogiri_node.name]

        unless rich_text_node
          raise "'#{nokogiri_node.name}' Node type, does not exist"
        end

        rich_text_node.new(nokogiri_node)
      end
    end
  end
end
