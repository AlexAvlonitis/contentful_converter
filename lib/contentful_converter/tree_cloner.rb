# frozen_string_literal: true

require 'contentful_converter/node_builder'
require 'contentful_converter/stack'

module ContentfulConverter
  class TreeCloner
    def self.nokogiri_to_rich_text(nokogiri_fragment)
      if nokogiri_fragment.children.empty?
        return NodeBuilder.build(nokogiri_fragment).to_h
      end

      new(nokogiri_fragment, Stack.new, Stack.new).traverse_and_clone
    end

    def initialize(nokogiri_fragment, noko_stack, rich_stack)
      @nokogiri_fragment = nokogiri_fragment
      @noko_stack = noko_stack
      @rich_stack = rich_stack
    end

    def traverse_and_clone
      initialize_stacks

      while noko_stack.any?
        noko_node = noko_stack.pop
        rich_node = rich_stack.pop

        next unless noko_node.children.any?

        children_traversal(noko_node, rich_node)
      end

      rich_root_node.to_h
    end

    private

    attr_reader :noko_stack, :rich_stack, :nokogiri_fragment

    def initialize_stacks
      noko_stack.add(nokogiri_fragment)
      rich_stack.add(rich_root_node)
    end

    def rich_root_node
      @rich_root_node ||= NodeBuilder.build(nokogiri_fragment)
    end

    def children_traversal(noko_node, rich_node)
      noko_node.children.each do |child_node|
        rich_child_node = NodeBuilder.build(child_node, rich_node)

        add_to_stacks(child_node, rich_child_node)

        rich_node.add_content(rich_child_node)
      end
    end

    def add_to_stacks(noko_node, rich_node)
      noko_stack.add(noko_node)
      rich_stack.add(rich_node)
    end
  end
end
