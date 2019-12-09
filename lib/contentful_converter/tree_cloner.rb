# frozen_string_literal: true

# Clones nokogiri fragment tree in a contentful specific tree structure
# Keeps track of objects and their children with a hash_map,
# value[0] index is always the corresponding rich_text node
# value[1..] indexes are the children ids of the key:node
# {
#   nokogiri_obj_id: [rich_text_node, noko_child_obj_id2, noko_child_obj_id3],
#   nokogiri_obj_id2: [rich_text_node]
#   nokogiri_obj_id3: [rich_text_node]
# }
# TODO: Refactor to something easier to follow

require 'contentful_converter/node_builder'

module ContentfulConverter
  class TreeCloner
    class << self
      def clone_to_rich_text(nokogiri_fragment)
        return Nodes::Document.new.to_h if nokogiri_fragment.children.empty?

        pre_order_traversal_map(nokogiri_fragment)
        construct_rich_text_tree

        rich_text_root_node = @hash_map.first[1].first
        rich_text_root_node.to_h
      end

      private

      def pre_order_traversal_map(nokogiri_fragment)
        @hash_map = {}
        stack = [nokogiri_fragment]

        while stack.any?
          node = stack.pop
          @hash_map[node.object_id] = [NodeBuilder.build(node)]

          next unless node.children.any?

          node.children.each do |ch_node|
            stack << ch_node
            @hash_map[node.object_id] << ch_node.object_id
          end
        end
      end

      def construct_rich_text_tree
        @hash_map.each do |_key, values|
          rich_text_node = values.first
          children_obj_ids = values[1..-1]
          next if children_obj_ids.empty?

          children_obj_ids.each do |obj_id|
            rich_text_node.add_content(@hash_map[obj_id][0])
          end
        end
      end
    end
  end
end
