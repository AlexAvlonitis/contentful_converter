# frozen_string_literal: true

require 'contentful_converter/node_builder'

module ContentfulConverter
  class TreeCloner
    class << self
      def nokogiri_to_rich_text(nokogiri_fragment)
        if nokogiri_fragment.children.empty?
          return NodeBuilder.build(nokogiri_fragment).to_h
        end

        traverse_and_clone(nokogiri_fragment).to_h
      end

      private

      def traverse_and_clone(nokogiri_fragment)
        rich_root_node = NodeBuilder.build(nokogiri_fragment)

        noko_stack = [nokogiri_fragment]
        rich_stack = [rich_root_node]

        while noko_stack.any?
          noko_node = noko_stack.pop
          rich_node = rich_stack.pop

          next unless noko_node.children.any?

          noko_node.children.each do |child_node|
            rich_child_node = NodeBuilder.build(child_node)

            noko_stack << child_node
            rich_stack << rich_child_node
            rich_node.add_content(rich_child_node)
          end
        end

        rich_root_node
      end
    end
  end
end
