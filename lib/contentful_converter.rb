# frozen_string_literal: true

require 'contentful_converter/converter'

module ContentfulConverter
  def self.convert(html)
    Converter.convert(html)
  end
end
