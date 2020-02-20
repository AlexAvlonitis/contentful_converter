# frozen_string_literal: true

require 'nokogiri'
require 'contentful_converter/configuration'

module ContentfulConverter
  class NokogiriBuilder
    class << self
      # By transforming the elements at this point,
      # nokogiri creates a tree that is accepted by contentful.
      def build(html)
        html_node = nokogiri_fragment(html)
        remove_forbidden_elements(html_node)
        normalize_nodes(html_node)
        html_node
      end

      private

      def nokogiri_fragment(html)
        Nokogiri::HTML.fragment(html)
      end

      def remove_forbidden_elements(html_node)
        remove_empty_links(html_node)
        return unless ContentfulConverter.configuration

        forbidden_nodes = ContentfulConverter.configuration.forbidden_nodes
        return if forbidden_nodes.empty?

        find_nodes(html_node, forbidden_nodes).each(&:remove)
      end

      def normalize_nodes(html_node)
        normalize_blocks(html_node)
        normalize_imgs(html_node)
        normalize_lists(html_node)
        normalize_embeds(html_node)
      end

      def normalize_blocks(html_node)
        find_nodes(html_node, %w[section div]).each do |elem|
          elem.swap(elem.children)
        end
      end

      def normalize_imgs(html_node)
        find_nodes(html_node, 'img').each { |elem| elem.name = 'embed' }
      end

      def normalize_lists(nokogiri_fragment)
        find_nodes(nokogiri_fragment, 'li').each do |li|
          wrap_parents_in_ul(li)
          wrap_children_in_single_p(li)
        end
      end

      def normalize_embeds(nokogiri_fragment)
        find_nodes(nokogiri_fragment, 'p embed').each do |embed_node|
          embed_node.parent.add_next_sibling(embed_node)
        end
      end

      def remove_empty_links(html_node)
        find_nodes(html_node, 'a').each { |n| n.remove unless n['href'] }
      end

      def wrap_parents_in_ul(node)
        return if node.parent.name == 'ul' || node.parent.name == 'ol'

        node.wrap('<ul>')
      end

      def wrap_children_in_single_p(node)
        return if node.children.count == 1 && node.children.first.name == 'p'

        find_nodes(node, 'p').each { |p_node| p_node.swap(p_node.children) }
        node_children = append_space_to_text_nodes(node.children.remove, node)

        node.add_child('<p>')
        node.at_css('p').children = node_children
        merge_text_nodes(node)
      end

      def append_space_to_text_nodes(children, node)
        children.each do |child|
          next if child.text.chomp.empty? || child.text.end_with?(' ')

          child.content = create_text_node("#{child.text} ", node)
        end
        children
      end

      def find_nodes(html_node, element)
        html_node.css(*element)
      end

      def create_text_node(text, html_node)
        Nokogiri::XML::Text.new(text, html_node)
      end

      def merge_text_nodes(node)
        Nokogiri::XML(node.to_xml)
      end
    end
  end
end
