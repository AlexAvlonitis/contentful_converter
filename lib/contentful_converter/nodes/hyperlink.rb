# frozen_string_literal: true

require 'contentful_converter/nodes/base'
require 'uri'

module ContentfulConverter
  module Nodes
    class Hyperlink < Base
      def to_h(params = options)
        super
      end

      private

      def type
        href_uri_value.scheme ? 'hyperlink' : 'entry-hyperlink'
      end

      def options
        href_uri_value.scheme ? hyperlink_option : hyperlink_entry_option
      end

      def hyperlink_option
        { data: { uri: href_uri_value.to_s } }
      end

      def hyperlink_entry_option
        {
          data: {
            target: {
              sys: {
                id: href_uri_value.to_s,
                type: "Link",
                linkType: "Entry"
              }
            }
          }
        }
      end

      def href_uri_value
        h = nokogiri_node['href']
        h ? URI(h) : URI('#empty')
      end
    end
  end
end
