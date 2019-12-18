# frozen_string_literal: true

require 'nokogiri'

module ContentfulConverter
  class NokogiriBuilder
    class << self
      def build(html)
        doc = create_nokogiri_fragment(sanitize(html))
        normalize_lists(doc)
        normalize_embeds(doc)
        doc
      end

      private

      def sanitize(html)
        doc = create_nokogiri_fragment(html)
        doc.css('section', 'div').each { |elem| elem.name = 'p' }
        doc.to_html
      end

      def create_nokogiri_fragment(html)
        Nokogiri::HTML.fragment(html)
      end

      def normalize_lists(nokogiri_fragment)
        nokogiri_fragment.css('li').each { |li| wrap_parents_in_ul(li) }
      end

      def normalize_embeds(nokogiri_fragment)
        nokogiri_fragment.css('p embed').each do |embed_node|
          embed_node.parent.add_next_sibling(embed_node)
        end
      end

      def wrap_parents_in_ul(node)
        return if node.parent.name == 'ul' || node.parent.name == 'ol'

        node.wrap('<ul>')
      end
    end
  end
end
