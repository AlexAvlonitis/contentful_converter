# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require 'contentful_converter/version'

Gem::Specification.new do |s|
  s.name        = 'contentful_converter'
  s.version     = ContentfulConverter::VERSION
  s.date        = '2019-12-07'
  s.summary     = 'Contentful HTML to Rich Text Converter'
  s.description = 'Converts HTML text to Rich Text Contentful specific JSON structure'
  s.authors     = ['Alex Avlonitis']
  s.files       = Dir.glob('{bin,lib}/**/*') + %w[README.md]
  s.homepage    = 'https://github.com/AlexAvlonitis/contentful_converter'
  s.license     = 'MIT'

  s.add_dependency 'nokogiri', '~> 1.6'
  s.add_development_dependency 'rspec', '~> 3.9'
end
