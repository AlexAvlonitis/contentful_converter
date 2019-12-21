# frozen_string_literal: true

require 'contentful_converter/nodes/base'
require 'uri'

module ContentfulConverter
  module Nodes
    class Hyperlink < Base
      private

      def type
        return 'asset-hyperlink' if !uri_scheme? && uri_extension?
        return 'entry-hyperlink' unless uri_scheme?

        'hyperlink'
      end

      def options
        return hyperlink_entry_option('Asset') if !uri_scheme? && uri_extension?
        return hyperlink_entry_option('Entry') unless uri_scheme?

        hyperlink_option
      end

      def hyperlink_option
        { data: { uri: parsed_link.to_s } }
      end

      def hyperlink_entry_option(type)
        {
          data: {
            target: {
              sys: {
                id: parsed_link.to_s.split('.').first,
                type: 'Link',
                linkType: type
              }
            }
          }
        }
      end

      def uri_scheme?
        parsed_link.scheme
      end

      def uri_extension?
        parsed_link.to_s.split('.')[1]
      end

      def parsed_link
        link_value ? URI(link_value) : URI('')
      end

      def link_value
        nokogiri_node[:href]
      end
    end
  end
end
