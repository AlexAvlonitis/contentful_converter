# frozen_string_literal: true

require 'spec_helper'
require 'contentful_converter/tree_cloner'
require 'contentful_converter/stack'

describe ContentfulConverter::TreeCloner do
  let(:subject) { described_class.new(nokogiri_fragment, noko_stack, rich_stack) }

  let(:html) { '<html><body><h1>Hello World</h1></body></html>' }
  let(:nokogiri_fragment) { Nokogiri::HTML.fragment(html) }
  let(:node_builder_klass) { ContentfulConverter::NodeBuilder }
  let(:noko_stack) do
    instance_double(ContentfulConverter::Stack, 'any?' => false, add: nil, pop: nil)
  end
  let(:rich_stack) do
    instance_double(ContentfulConverter::Stack, 'any?' => false, add: nil, pop: nil)
  end

  let(:node_doc_instance) do
    instance_double(ContentfulConverter::Nodes::Document)
  end
  let(:node_doc_hash) do
    {
      nodeType: 'document',
      data: {},
      content: [node_header_hash]
    }
  end
  let(:node_header_instance) do
    instance_double(ContentfulConverter::Nodes::Header)
  end
  let(:node_header_hash) do
    {
      nodeType: 'heading-1',
      data: {},
      content: [node_text_hash]
    }
  end
  let(:node_text_instance) do
    instance_double(ContentfulConverter::Nodes::Text)
  end
  let(:node_text_hash) do
    {
      'data': {},
      'marks': [],
      'value': 'Hello World',
      'nodeType': 'text'
    }
  end

  before do
    allow(node_builder_klass)
      .to receive(:build)
      .with(nokogiri_fragment)
      .and_return(node_doc_instance)

    allow(node_builder_klass)
      .to receive(:build)
      .with(nokogiri_fragment.child, node_doc_instance)
      .and_return(node_header_instance)

    allow(node_builder_klass)
      .to receive(:build)
      .with(nokogiri_fragment.css('h1').children.first, node_header_instance)
      .and_return(node_text_instance)

    allow(node_doc_instance).to receive(:to_h) { node_doc_hash }
    allow(node_doc_instance).to receive(:to_h) { node_doc_hash }
    allow(node_doc_instance).to receive(:add_content).with(node_header_instance)
    allow(node_header_instance).to receive(:add_content).with(node_text_instance)
  end

  describe '#traverse_and_clone' do
    context 'when we pass in a valid nokogiri fragment' do
      it 'clones the tree and converts the nodes into custom rich_text hash' do
        expect(subject.traverse_and_clone).to eq(node_doc_hash)
      end
    end
  end
end
