# frozen_string_literal: true

require 'spec_helper'
require 'contentful_converter/converter'

describe ContentfulConverter::Converter do
  describe 'Convert' do
    context 'On success' do
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
              content: []
            },
            {
              nodeType: 'paragraph',
              data: {},
              content: [
                {
                  marks: [],
                  value: 'paragraph text',
                  nodeType: 'text',
                  data: {}
                }
              ]
            },
            {
              nodeType: 'heading-1',
              data: {},
              content: [
                {
                  marks: [],
                  value: 'hello world',
                  nodeType: 'text',
                  data: {}
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
        let(:html) do
          '<html><body><div><h1>hello world</h1><div><p>paragraph text<p></div></div></body></html>'
        end
        let(:expected_hash) do
          {
            nodeType: 'document',
            data: {},
            content: [
              {
                nodeType: 'paragraph',
                data: {},
                content: []
              },
              {
                nodeType: 'heading-1',
                data: {},
                content: [
                  {
                    marks: [],
                    value: 'hello world',
                    nodeType: 'text',
                    data: {}
                  }
                ]
              },
              {
                nodeType: 'paragraph',
                data: {},
                content: []
              },
              {
                nodeType: 'paragraph',
                data: {},
                content: [
                  {
                    marks: [],
                    value: 'paragraph text',
                    nodeType: 'text',
                    data: {}
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
        end

        it 'convert html to rich text correctly' do
          expect(described_class.convert(html)).to eq expected_hash
        end
      end

      context 'When we have a link' do
        context 'When the link has protocol e.g http(s)' do
          let(:html) do
            '<html><body><a href="https://google.com">click me</a></body></html>'
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
                      nodeType: 'hyperlink',
                      data: {
                        uri: 'https://google.com'
                      },
                      content: [
                        {
                          marks: [],
                          value: 'click me',
                          nodeType: 'text',
                          data: {}
                        }
                      ]
                    }
                  ]
                }
              ]
            }
          end

          it 'creates a normal hyperlink structure' do
            expect(described_class.convert(html)).to eq expected_hash
          end
        end

        context 'when the link does not have a protocol' do
          let(:html) do
            '<html><body><a href="12398sadkcw">hyperlink entry</a></body></html>'
          end
          let(:expected_hash) do
            {
              nodeType: 'document',
              data: {},
              content: [
                {
                  nodeType: "paragraph",
                  data: {},
                  content: [
                    {
                      nodeType: "entry-hyperlink",
                      data: {
                        target: {
                          sys: {
                            id: "12398sadkcw",
                            type: "Link",
                            linkType: "Entry"
                          }
                        }
                      },
                      content: [
                        {
                          data: {},
                          marks: [],
                          value: "hyperlink entry",
                          nodeType: "text"
                        }
                      ]
                    }
                  ]
                }
              ]
            }
          end

          it 'creates a hyperlink entry with the href as a link id' do
            expect(described_class.convert(html)).to eq expected_hash
          end
        end

        context 'when the link does not have a protocol and has an extension' do
          let(:html) do
            '<html><body><a href="12398sadkcw.docx">asset entry</a></body></html>'
          end
          let(:expected_hash) do
            {
              nodeType: 'document',
              data: {},
              content: [
                {
                  nodeType: "paragraph",
                  data: {},
                  content: [
                    {
                      nodeType: "asset-hyperlink",
                      data: {
                        target: {
                          sys: {
                            id: "12398sadkcw",
                            type: "Link",
                            linkType: "Asset"
                          }
                        }
                      },
                      content: [
                        {
                          data: {},
                          marks: [],
                          value: "asset entry",
                          nodeType: "text"
                        }
                      ]
                    }
                  ]
                }
              ]
            }
          end

          it 'creates an asset entry with the href as a link id' do
            expect(described_class.convert(html)).to eq expected_hash
          end
        end

        context 'when the link is blank' do
          let(:html) do
            '<html><body><a href="">click</a></body></html>'
          end
          let(:expected_hash) do
            {
              nodeType: 'document',
              data: {},
              content: [
                {
                  nodeType: "paragraph",
                  data: {},
                  content: [
                    {
                      nodeType: "entry-hyperlink",
                      data: {
                        target: {
                          sys: {
                            id: nil,
                            type: "Link",
                            linkType: "Entry"
                          }
                        }
                      },
                      content: [
                        {
                          data: {},
                          marks: [],
                          value: "click",
                          nodeType: "text"
                        }
                      ]
                    }
                  ]
                }
              ]
            }
          end

          it 'creates an entry hyperlink with nil ID' do
            expect(described_class.convert(html)).to eq expected_hash
          end
        end

        context 'when there is an embed html element' do
          context 'when it is an entry' do
            let(:html) { '<embed src="2vtrc4TqIHNjolX299pik7" type="entry"/>' }
            let(:expected_hash) do
              {
                nodeType: "document",
                data: {},
                content: [
                  {
                    data: {
                      target: {
                        sys: {
                          id: "2vtrc4TqIHNjolX299pik7",
                          type: "Link",
                          linkType: "Entry"
                        }
                      }
                    },
                    content: [],
                    nodeType: "embedded-entry-block"
                  }
                ]
              }
            end

            it 'creates an embedded entry block with the src as an ID' do
              expect(described_class.convert(html)).to eq expected_hash
            end
          end

          context 'when it is an asset' do
            let(:html) { '<embed src="2vtrc4TqIHNjolX299pik7" type="asset"/>' }
            let(:expected_hash) do
              {
                nodeType: "document",
                data: {},
                content: [
                  {
                    data: {
                      target: {
                        sys: {
                          id: "2vtrc4TqIHNjolX299pik7",
                          type: "Link",
                          linkType: "Asset"
                        }
                      }
                    },
                    content: [],
                    nodeType: "embedded-asset-block"
                  }
                ]
              }
            end

            it 'creates an embedded asset block with the src as an ID' do
              expect(described_class.convert(html)).to eq expected_hash
            end

            context 'when the embed element does not have a type' do
              let(:html) { '<embed src="2vtrc4TqIHNjolX299pik7"/>' }

              it 'defaults to embedded-asset-block' do
                expect(described_class.convert(html)).to eq expected_hash
              end
            end
          end
        end

        context 'when there is an image' do
          let(:html) { '<img src="2vtrc4TqIHNjolX299pik7" />' }
          let(:expected_hash) do
            {
              nodeType: "document",
              data: {},
              content: [
                {
                  data: {
                    target: {
                      sys: {
                        id: "2vtrc4TqIHNjolX299pik7",
                        type: "Link",
                        linkType: "Asset"
                      }
                    }
                  },
                  content: [],
                  nodeType: "embedded-asset-block"
                }
              ]
            }
          end

          it 'creates an embedded asset block with the src as an ID' do
            expect(described_class.convert(html)).to eq expected_hash
          end
        end
      end

      context 'When we have a list item' do
        let(:html) do
          '<html><body><ol><li><p>list text</p></li></ol></body></html>'
        end
        let(:expected_hash) do
          {
            nodeType: 'document',
            data: {},
            content: [
              {
                nodeType: 'ordered-list',
                data: {},
                content: [
                  {
                    nodeType: 'list-item',
                    data: {},
                    content: [
                      {
                        nodeType: 'paragraph',
                        data: {},
                        content: [
                          {
                            marks: [],
                            value: 'list text',
                            nodeType: 'text',
                            data: {}
                          }
                        ]
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
      end

      context 'When we have an incomplete list item' do
        let(:html) do
          '<html><body><li>list text</li></body></html>'
        end
        let(:expected_hash) do
          {
            nodeType: 'document',
            data: {},
            content: [
              {
                nodeType: 'unordered-list',
                data: {},
                content: [
                  {
                    nodeType: 'list-item',
                    data: {},
                    content: [
                      {
                        nodeType: 'paragraph',
                        data: {},
                        content: [
                          {
                            marks: [],
                            value: 'list text',
                            nodeType: 'text',
                            data: {}
                          }
                        ]
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
      end

      context 'When we have a list of elements that need P wrapping' do
        context 'with marks' do
          [
            ['b', 'strong'],
            ['u', 'underline'],
            ['i', 'italic'],
            ['code', 'code']
          ].each do |elem, text|
            let(:html) do
              "<html><body><#{elem}>underline text</#{elem}></body></html>"
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
                        marks: [
                          { type: text }
                        ],
                        value: 'underline text',
                        nodeType: 'text',
                        data: {}
                      }
                    ]
                  }
                ]
              }
            end

            it 'convert html to rich text correctly' do
              expect(described_class.convert(html)).to eq expected_hash
            end
          end
        end
      end

      context 'when there is a blockquote element' do
        let(:html) do
          "<html><body><blockquote>blockquote text</blockquote></body></html>"
        end
        let(:expected_hash) do
          {
            nodeType: 'document',
            data: {},
            content: [
              {
                nodeType: 'blockquote',
                data: {},
                content: [
                  {
                    nodeType: 'paragraph',
                    data: {},
                    content: [
                      {
                        marks: [],
                        value: 'blockquote text',
                        nodeType: 'text',
                        data: {}
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
      end

      context 'when there is an hr element' do
        let(:html) do
          "<html><body><hr></body></html>"
        end
        let(:expected_hash) do
          {
            nodeType: 'document',
            data: {},
            content: [
              {
                nodeType: 'hr',
                data: {},
                content: []
              }
            ]
          }
        end

        it 'convert html to rich text correctly' do
          expect(described_class.convert(html)).to eq expected_hash
        end
      end

      context 'when a text element is blank' do
        let(:html) do
          "<html><body><p>    </p></body></html>"
        end
        let(:expected_hash) do
          {
            nodeType: 'document',
            data: {},
            content: [
              {
                nodeType: 'paragraph',
                data: {},
                content: []
              }
            ]
          }
        end

        it 'does not create a text element' do
          expect(described_class.convert(html)).to eq expected_hash
        end
      end
    end

    context 'On failure' do
      context "When we don't input a string" do
        it 'raises argument error' do
          expect { described_class.convert(nil) }.to raise_error(ArgumentError)
        end
      end

      context 'when there is an embed html element' do
        context 'and the type is wrong' do
          let(:html) { '<embed src="2vtrc4TqIHNjolX299pik7" type="link"/>' }

          it 'raises an error' do
            expect { described_class.convert(html) }
              .to raise_error('Incorrect embed type')
          end
        end
      end
    end
  end
end
