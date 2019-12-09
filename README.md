## Contentful HTML to Rich Text converter

Converts plain html string to contentful specific rich_text hash structure.
*WIP, does not cover all html elements, contributions are welcome*

### Install
```ruby
# Rails
gem 'contentful_converter'

# Ruby
gem install 'contentful_converter'

require 'contentful_converter

```

### Run

```ruby
ContentfulConverter.convert('<h3>hello world</h3>')

=> {:nodeType=>"document",
 :data=>{},
 :content=>
  [{:nodeType=>"header-3",
    :data=>{},
    :content=>
     [{:marks=>[],
       :value=>"hello world",
       :nodeType=>"text",
       :data=>{},
       :content=>[]}]}]}

```
