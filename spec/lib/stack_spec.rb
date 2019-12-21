# frozen_string_literal: true

require 'spec_helper'
require 'contentful_converter/stack'

describe ContentfulConverter::Stack do
  let(:stack) { described_class.new }
  let(:value) { double(:value) }

  before { stack.add(value) }

  describe '#add' do
    it 'adds a value in the stack' do
      expect(stack.instance_variable_get(:@stack).first).to eq value
    end
  end

  describe '#pop' do
    it 'removes a value from the stack' do
      stack.pop
      expect(stack.instance_variable_get(:@stack)).to be_empty
    end
  end

  describe '#any?' do
    it 'checks if there is any value in the stack' do
      expect(stack.any?).to be_truthy
    end
  end
end
