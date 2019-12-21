# frozen_string_literal: true

module ContentfulConverter
  class Stack
    def initialize
      @stack = []
    end

    def add(value)
      @stack << value
    end

    def pop
      @stack.pop
    end

    def any?
      @stack.any?
    end
  end
end
