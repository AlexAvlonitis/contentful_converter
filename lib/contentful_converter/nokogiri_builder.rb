# frozen_string_literal: true

require 'nokogiri'

module ContentfulConverter
  class NokogiriBuilder
    class << self
      def build(html)
        doc = Nokogiri::HTML.fragment(sanitize(html))
        doc = normalize_lists(doc) if find_li(doc).any?
        doc
      end

      private

      def sanitize(html)
        html = html.dup
        html.gsub!('div>', 'p>')
        html.gsub!('section>', 'p>')
        html
      end

      def normalize_lists(nokogiri_fragment)
        find_li(nokogiri_fragment).each do |li_node|
          wrap_parents_in_ul(li_node)
          wrap_children_in_paragraph(li_node, nokogiri_fragment)
        end

        nokogiri_fragment
      end

      def find_li(nokogiri_fragment)
        nokogiri_fragment.css('li')
      end

      def wrap_children_in_paragraph(node, nokogiri_fragment)
        p_node = Nokogiri::XML::Node.new('p', nokogiri_fragment)
        node = add_p_children(p_node, node)
        node.children = p_node
        node
      end

      def add_p_children(p_node, node)
        node_child_count = node.children.count

        node.children.each.with_index(1) do |child, i|
          if child.name == 'p'
            p_node << (node_child_count == i ? child.content : "#{child.content} ")
            next
          end
          p_node << child
        end
        node
      end

      def wrap_parents_in_ul(node)
        return if node.parent.name == 'ul' || node.parent.name == 'ol'

        node.wrap('<ul>')
      end
    end
  end
end
