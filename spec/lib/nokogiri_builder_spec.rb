# frozen_string_literal: true

require 'spec_helper'
require 'contentful_converter/nokogiri_builder'

describe ContentfulConverter::NokogiriBuilder do
  describe '.build' do
    context 'when we pass in a list without an appropriate parent' do
      let(:html) { '<li><p>test</p></li>' }
      let(:expected_html) { '<ul><li><p>test</p></li></ul>' }

      context 'when the parent is not a ul' do
        it 'returns the the list with a ul wrapper' do
          result = described_class.build(html)
          expect(result.to_html).to eq(expected_html)
        end
      end

      context 'when we pass in a correct list' do
        let(:html) { '<ol><li><p>test</p></li></ol>' }
        let(:expected_html) { '<ol><li><p>test</p></li></ol>' }

        it 'returns the list as is' do
          result = described_class.build(html)
          expect(result.to_html).to eq(expected_html)
        end
      end

      context 'when the list has multiple p children' do
        let(:html) { '<ol><li><p>test</p><p>test2</p></li></ol>' }
        let(:expected_html) { "<ol><li>\n<p>test</p>\n<p>test2</p>\n</li></ol>" }

        it 'wraps the children in a single p element' do
          result = described_class.build(html)
          expect(result.to_html).to eq(expected_html)
        end
      end

      context 'when the list has multiple mixed children' do
        let(:html) { '<ol><li><p>test</p><u>test2</u><i>test2</i></li></ol>' }
        let(:expected_html) { "<ol><li>\n<p>test</p>\n<u>test2</u><i>test2</i>\n</li></ol>" }

        it 'wraps the children in a single p element keeping the rest as they are' do
          result = described_class.build(html)
          expect(result.to_html).to eq(expected_html)
        end
      end

      context 'when the html has a section element' do
        let(:html) { '<section class="test"><p>test</p></section>' }
        let(:expected_html) { '<p class="test"></p><p>test</p>' }

        it 'converts the section into <p> and removes the wrapping' do
          result = described_class.build(html)
          expect(result.to_html).to eq(expected_html)
        end
      end

      context 'when the html has a nested embed' do
        let(:html) { '<section>test<embed /></section>' }
        let(:expected_html) { '<p>test</p><embed></embed>' }

        it 'moves the embed out of the paragraph' do
          result = described_class.build(html)
          expect(result.to_html).to eq(expected_html)
        end
      end

      context 'when the html has an <img> element' do
        let(:html) { '<section>test<img src="test.jpg" /></section>' }
        let(:expected_html) { '<p>test</p><embed src="test.jpg"></embed>' }

        it 'converts it to embed and moves it out of the paragraph' do
          result = described_class.build(html)
          expect(result.to_html).to eq(expected_html)
        end
      end

      context 'when the html has a <table> element' do
        let(:html) { '<p>test<table><th>col1</th></table></p>' }
        let(:expected_html) { '<p>test</p>' }

        it 'removes the tables by default' do
          ContentfulConverter.configure.configuration.forbidden_nodes = 'table', 'script'
          result = described_class.build(html)
          expect(result.to_html).to eq(expected_html)
        end

        context 'when we remove the table from the configuration' do
          let(:expected_html) { '<p>test</p><table><th>col1</th></table>' }

          it 'keeps the table' do
            ContentfulConverter.configure.configuration.forbidden_nodes = []
            result = described_class.build(html)
            expect(result.to_html).to eq(expected_html)
          end
        end
      end

      context 'when the html has a <script> element' do
        let(:html) { '<p>test<script>alert(1)</script></p>' }
        let(:expected_html) { '<p>test</p>' }

        it 'removes the scripts by default' do
          ContentfulConverter.configure.configuration.forbidden_nodes = 'script'
          result = described_class.build(html)
          expect(result.to_html).to eq(expected_html)
        end
      end
    end
  end
end
