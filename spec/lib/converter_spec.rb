# frozen_string_literal: true

require 'spec_helper'
require 'contentful_converter/converter'

describe ContentfulConverter::Converter do
  let(:html) { '<html><body><h1>hello world</h1><p>hi</p></body></html>' }
  let(:nokogiri_fragment) { double(:nokogiri_fragment) }

  before do
    allow(ContentfulConverter::NokogiriBuilder)
      .to receive(:build)
      .with(html)
      .and_return(nokogiri_fragment)

    allow(ContentfulConverter::TreeCloner)
      .to receive(:nokogiri_to_rich_text)
      .with(nokogiri_fragment)
      .and_return(Hash)
  end

  describe '.convert' do
    it 'forwards nokogiri fragment to TreeCloner.nokogiri_to_rich_text' do
      expect(ContentfulConverter::TreeCloner)
        .to receive(:nokogiri_to_rich_text)
        .with(nokogiri_fragment)
        .and_return(Hash)

      described_class.convert(html)
    end
  end
end
