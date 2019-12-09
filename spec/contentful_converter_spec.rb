require 'spec_helper'
require 'contentful_converter'

describe ContentfulConverter do
  let(:converter) { ContentfulConverter::Converter }
  let(:html) { '<html><body><h1>hello world</h1><p>hi</p></body></html>' }

  before do
    allow(converter).to receive(:convert).with(html) { {} }
  end

  describe '.convert' do
    it 'sends convert message with html param to converter class' do
      expect(ContentfulConverter::Converter)
        .to receive(:convert)
        .with(html)
        .and_return(Hash)

      described_class.convert(html)
    end
  end
end
