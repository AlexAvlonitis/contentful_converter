# frozen_string_literal: true

require 'nokogiri'
require 'contentful_converter/configuration'

module ContentfulConverter
  class NokogiriBuilder
    class << self
      def build(html)
        doc = create_nokogiri_fragment(transform(html))
        normalize_lists(doc)
        normalize_embeds(doc)
        doc
      end

      private

      # By transforming the elements at this point,
      # nokogiri creates a tree that is accepted by contentful.
      def transform(html)
        doc = create_nokogiri_fragment(html)
        remove_forbidden_elements(doc)
        find_nodes(doc, %w[section div]).each { |elem| elem.name = 'p' }
        find_nodes(doc, 'img').each { |elem| elem.name = 'embed' }
        doc.to_html
      end

      def create_nokogiri_fragment(html)
        Nokogiri::HTML.fragment(html)
      end

      def remove_forbidden_elements(doc)
        forbidden_nodes = ContentfulConverter.configure.configuration.forbidden_nodes
        remove_empty_links(doc)
        return if forbidden_nodes.empty?

        find_nodes(doc, forbidden_nodes).each(&:remove)
      end

      def normalize_lists(nokogiri_fragment)
        find_nodes(nokogiri_fragment, 'li').each { |li| wrap_parents_in_ul(li) }
      end

      def normalize_embeds(nokogiri_fragment)
        find_nodes(nokogiri_fragment, 'p embed').each do |embed_node|
          embed_node.parent.add_next_sibling(embed_node)
        end
      end

      def remove_empty_links(doc)
        find_nodes(doc, 'a').each { |n| n.remove unless n['href'] }
      end

      def find_nodes(doc, element)
        doc.css(*element)
      end

      def wrap_parents_in_ul(node)
        return if node.parent.name == 'ul' || node.parent.name == 'ol'

        node.wrap('<ul>')
      end
    end
  end
end
