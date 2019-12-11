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
        find_li(nokogiri_fragment).each { |li_node| wrap_parents_in_ul(li_node) }

        nokogiri_fragment
      end

      def find_li(nokogiri_fragment)
        nokogiri_fragment.css('li')
      end

      def wrap_parents_in_ul(node)
        return if node.parent.name == 'ul' || node.parent.name == 'ol'

        node.wrap('<ul>')
      end
    end
  end
end
