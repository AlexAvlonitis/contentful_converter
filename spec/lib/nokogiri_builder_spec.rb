# frozen_string_literal: true

require 'spec_helper'
require 'contentful_converter/nokogiri_builder'

describe ContentfulConverter::NokogiriBuilder do
  describe '.build' do
    context 'when we pass in a list without an appropriate parent' do
      let(:html) { '<li><p>tester testing</p></li>' }
      let(:expected_html) { '<ul><li><p>tester testing</p></li></ul>' }

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
        let(:html) { '<ol><li><p>testing</p><p>test2</p></li></ol>' }
        let(:expected_html) { "<ol><li><p>testing test2 </p></li></ol>" }

        it 'wraps the children in a single p element and adds spaces' do
          result = described_class.build(html)
          expect(result.to_html).to eq(expected_html)
        end
      end

      context 'when the list has multiple mixed children' do
        let(:html) { '<ol><li><p>test</p><u>test2</u><i>test2</i></li></ol>' }
        let(:expected_html) { "<ol><li><p>test <u>test2 </u><i>test2 </i></p></li></ol>" }

        it 'wraps the children in a single p element and adds spaces' do
          result = described_class.build(html)
          expect(result.to_html).to eq(expected_html)
        end
      end

      context 'when the html has a section element' do
        let(:html) { '<section class="test"><p>test</p></section>' }
        let(:expected_html) { '<p>test</p>' }

        it 'removes the wrapping' do
          result = described_class.build(html)
          expect(result.to_html).to eq(expected_html)
        end
      end

      context 'when the html has a div element' do
        let(:html) { '<div><p>test</p></div>' }
        let(:expected_html) { '<p>test</p>' }

        it 'removes the wrapping' do
          result = described_class.build(html)
          expect(result.to_html).to eq(expected_html)
        end
      end

      context 'when the html has a nested embed' do
        let(:html) { '<section>test<embed /></section>' }
        let(:expected_html) { 'test<embed></embed>' }

        it 'moves the embed out of the paragraph' do
          result = described_class.build(html)
          expect(result.to_html).to eq(expected_html)
        end
      end

      context 'when the html has an <img> element' do
        let(:html) { '<section>test<img src="test.jpg" /></section>' }
        let(:expected_html) { 'test<embed src="test.jpg"></embed>' }

        it 'converts it to embed and moves it out of the paragraph' do
          result = described_class.build(html)
          expect(result.to_html).to eq(expected_html)
        end
      end

      context 'when the html has a <table> element' do
        let(:html) { '<p>test<table><th>col1</th></table></p>' }
        let(:expected_html) { '<p>test</p>' }

        it 'removes the tables by default' do
          ContentfulConverter.configuration.forbidden_nodes = 'table', 'script'
          result = described_class.build(html)
          expect(result.to_html).to eq(expected_html)
        end

        context 'when we remove the table from the configuration' do
          let(:expected_html) { '<p>test</p><table><th>col1</th></table>' }

          it 'keeps the table' do
            ContentfulConverter.configuration.forbidden_nodes = []
            result = described_class.build(html)
            expect(result.to_html).to eq(expected_html)
          end
        end
      end

      context 'when the html has a <script> element' do
        let(:html) { '<p>test<script>alert(1)</script></p>' }
        let(:expected_html) { '<p>test</p>' }

        it 'removes the scripts by default' do
          ContentfulConverter.configuration.forbidden_nodes = 'script'
          result = described_class.build(html)
          expect(result.to_html).to eq(expected_html)
        end
      end
    end

    context 'when the html has a <a> element without source' do
      let(:html) { '<p>test<a class="test">link</a></p>' }
      let(:expected_html) { '<p>test</p>' }

      it 'removes it' do
        result = described_class.build(html)
        expect(result.to_html).to eq(expected_html)
      end
    end
  end
end
