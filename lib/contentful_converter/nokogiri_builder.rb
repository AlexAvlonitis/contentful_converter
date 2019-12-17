# frozen_string_literal: true

require 'nokogiri'

module ContentfulConverter
  class NokogiriBuilder
    class << self
      def build(html)
        doc = create_nokogiri_fragment(sanitize(html))
        doc = normalize_lists(doc) if find_li(doc).any?
        doc
      end

      private

      def create_nokogiri_fragment(html)
        Nokogiri::HTML.fragment(html)
      end

      def sanitize(html)
        doc = create_nokogiri_fragment(html)
        doc.css('section', 'div').each { |elem| elem.name = 'p' }
        doc.to_html
      end

      def normalize_lists(nokogiri_fragment)
        find_li(nokogiri_fragment).each { |li_node| wrap_parents_in_ul(li_node) }
        find_list_groups(nokogiri_fragment).each { |elem| clear_children(elem) }

        nokogiri_fragment
      end

      def find_li(nokogiri_fragment)
        nokogiri_fragment.css('li')
      end

      def find_list_groups(nokogiri_fragment)
        nokogiri_fragment.css('ol', 'ul')
      end

      def clear_children(elem)
        elem.children.each { |child| child.remove unless child.name == 'li' }
      end

      def wrap_parents_in_ul(node)
        return if node.parent.name == 'ul' || node.parent.name == 'ol'

        node.wrap('<ul>')
      end
    end
  end
end
