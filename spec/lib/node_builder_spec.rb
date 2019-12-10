# frozen_string_literal: true

require 'spec_helper'
require 'contentful_converter/node_builder'

describe ContentfulConverter::NodeBuilder do
  let(:nokogiri_node) { double(:nokogiri_node, name: nil) }

  describe '.build' do
    context 'when we pass in a valid nokogiri node' do
      context 'when we pass in #docoment-fragment node' do
        it 'instantiates a Document rich_text node' do
          allow(nokogiri_node).to receive(:name) { '#document-fragment' }

          expect(described_class.build(nokogiri_node))
            .to be_an_instance_of(ContentfulConverter::Nodes::Document)
        end
      end

      context 'when we pass in header nokogiri nodes' do
        it 'instantiates a Header rich_text node' do
          ['h1', 'h2', 'h3', 'h4', 'h5', 'h6'].each do |v|
            allow(nokogiri_node).to receive(:name) { v }

            expect(described_class.build(nokogiri_node))
              .to be_an_instance_of(ContentfulConverter::Nodes::Header)
          end
        end
      end

      context 'when we pass in text nokogiri node' do
        it 'instantiates a Text rich_text node' do
          allow(nokogiri_node).to receive(:name) { 'text' }

          expect(described_class.build(nokogiri_node))
            .to be_an_instance_of(ContentfulConverter::Nodes::Text)
        end
      end

      context 'when we pass in underline text nokogiri node' do
        it 'instantiates an Underline rich_text node' do
          allow(nokogiri_node).to receive(:name) { 'u' }

          expect(described_class.build(nokogiri_node))
            .to be_an_instance_of(ContentfulConverter::Nodes::Underline)
        end
      end

      context 'when we pass in italic text nokogiri node' do
        it 'instantiates an Italic rich_text node' do
          allow(nokogiri_node).to receive(:name) { 'i' }

          expect(described_class.build(nokogiri_node))
            .to be_an_instance_of(ContentfulConverter::Nodes::Italic)
        end
      end

      context 'when we pass in code text nokogiri node' do
        it 'instantiates a Code rich_text node' do
          allow(nokogiri_node).to receive(:name) { 'code' }

          expect(described_class.build(nokogiri_node))
            .to be_an_instance_of(ContentfulConverter::Nodes::Code)
        end
      end

      context 'when we pass in bold text nokogiri node' do
        it 'instantiates a Strong rich_text node' do
          ['strong', 'b'].each do |v|
            allow(nokogiri_node).to receive(:name) { v }

            expect(described_class.build(nokogiri_node))
              .to be_an_instance_of(ContentfulConverter::Nodes::Strong)
          end
        end
      end

      context 'when we pass in paragraph nokogiri node' do
        it 'instantiates a Paragraph rich_text node' do
          ['p', 'div', 'br', 'section'].each do |v|
            allow(nokogiri_node).to receive(:name) { v }

            expect(described_class.build(nokogiri_node))
              .to be_an_instance_of(ContentfulConverter::Nodes::Paragraph)
          end
        end
      end

      context 'when we pass in hyperlink nokogiri node' do
        it 'instantiates an Hyperlink rich_text node' do
          allow(nokogiri_node).to receive(:name) { 'a' }

          expect(described_class.build(nokogiri_node))
            .to be_an_instance_of(ContentfulConverter::Nodes::Hyperlink)
        end
      end
    end
  end
end
