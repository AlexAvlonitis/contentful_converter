# frozen_string_literal: true

module ContentfulConverter
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration) if block_given?
    self
  end

  class Configuration
    attr_reader :forbidden_nodes

    def initialize
      @forbidden_nodes = []
    end

    def forbidden_nodes=(*nodes)
      @forbidden_nodes = nodes.flatten.uniq
    end
  end
end
