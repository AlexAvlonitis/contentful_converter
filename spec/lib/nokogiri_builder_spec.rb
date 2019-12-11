# frozen_string_literal: true

require 'spec_helper'
require 'contentful_converter/nokogiri_builder'

describe ContentfulConverter::NokogiriBuilder do
  describe '.build' do
    context 'when we pass in a list without an appropriate parent' do
      let(:html) { '<li><p>test</p></li>' }
      let(:expected_html) { '<ul><li><p>test</p></li></ul>' }

      context 'when the parent is not a ul' do
        it 'returns the corrent output' do
          result = described_class.build(html)
          expect(result.at('ul').to_html).to eq(expected_html)
        end
      end

      context 'when we pass in a list without an appropriate parent or children' do
        let(:html) { '<li>test</li>' }

        context 'when the parent is not a ul and children not a paragraph' do
          it 'returns the corrent output' do
            result = described_class.build(html)
            expect(result.at('ul').to_html).to eq(expected_html)
          end
        end
      end

      context 'when we pass in a correct list' do
        let(:html) { '<ol><li><p>test</p></li></ol>' }
        let(:expected_html) { '<ol><li><p>test</p></li></ol>' }

        it 'returns the list as is' do
          result = described_class.build(html)
          expect(result.at('ol').to_html).to eq(expected_html)
        end
      end

      context 'when the list has multiple p children' do
        let(:html) { '<ol><li><p>test</p><p>test2</p></li></ol>' }
        let(:expected_html) { '<ol><li><p>test test2</p></li></ol>' }

        it 'wraps the children in a single p element' do
          result = described_class.build(html)
          expect(result.at('ol').to_html).to eq(expected_html)
        end
      end

      context 'when the list has multiple mixed children' do
        let(:html) { '<ol><li><p>test</p><u>test2</u><i>test2</i></li></ol>' }
        let(:expected_html) { '<ol><li><p>test <u>test2</u><i>test2</i></p></li></ol>' }

        it 'wraps the children in a single p element keeping the rest as they are' do
          result = described_class.build(html)
          expect(result.at('ol').to_html).to eq(expected_html)
        end
      end
    end
  end
end
