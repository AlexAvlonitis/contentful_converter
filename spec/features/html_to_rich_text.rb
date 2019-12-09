# frozen_string_literal: true

require 'spec_helper'
require 'contentful_converter/converter'

describe ContentfulConverter::Converter do
  describe 'Convert' do
    context 'On success' do
      let(:html) do
        '<html><body><div><p>paragraph text</p><h1>hello world</h1></div></body></html>'
      end
      let(:expected_hash) do
        {
          nodeType: 'document',
          data: {},
          content: [
            {
              nodeType: 'paragraph',
              data: {},
              content: [
                {
                  nodeType: 'paragraph',
                  data: {},
                  content: [
                    {
                      marks: [],
                      value: 'paragraph text',
                      nodeType: 'text',
                      data: {},
                      content: []
                    }
                  ]
                },
                {
                  nodeType: 'header-1',
                  data: {},
                  content: [
                    {
                      marks: [],
                      value: 'hello world',
                      nodeType: 'text',
                      data: {},
                      content: []
                    }
                  ]
                }
              ]
            }
          ]
        }
      end

      it 'convert html to rich text correctly' do
        expect(described_class.convert(html)).to eq expected_hash
      end

      context 'When we have a deeply nested html' do
        let(:html2) do
          '<html><body><div><h1>hello world</h1><div><p>paragraph text<p></div></div></body></html>'
        end
        let(:expected_hash2) do
          {
            nodeType: 'document',
            data: {},
            content: [
              {
                nodeType: 'paragraph',
                data: {},
                content: [
                  {
                    nodeType: 'header-1',
                    data: {},
                    content: [
                      {
                        marks: [],
                        value: 'hello world',
                        nodeType: 'text',
                        data: {},
                        content: []
                      }
                    ]
                  },
                  {
                    nodeType: 'paragraph',
                    data: {},
                    content: [
                      {
                        nodeType: 'paragraph',
                        data: {},
                        content: [
                          {
                            marks: [],
                            value: 'paragraph text',
                            nodeType: 'text',
                            data: {},
                            content: []
                          }
                        ]
                      },
                      {
                        nodeType: 'paragraph',
                        data: {},
                        content: []
                      }
                    ]
                  }
                ]
              }
            ]
          }
        end

        it 'convert html to rich text correctly' do
          expect(described_class.convert(html2)).to eq expected_hash2
        end
      end
    end

    context 'On failure' do
      context "When we don't input a string" do
        it 'raises argument error' do
          expect { described_class.convert(nil) }.to raise_error(ArgumentError)
        end
      end

      context 'When we our html does not have any elements' do
        let(:expected_hash) do
          {
            nodeType: 'document',
            data: {},
            content: []
          }
        end

        it 'returns a single Document hash' do
          expect(described_class.convert('<html><html>')).to eq expected_hash
        end
      end
    end
  end
end
