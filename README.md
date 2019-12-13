## Contentful HTML to Rich Text converter

[![Build Status](https://travis-ci.org/AlexAvlonitis/contentful_converter.svg?branch=master)](https://travis-ci.org/AlexAvlonitis/contentful_converter)

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

# OUTPUT
{
  :nodeType=>"document",
  :data=>{},
  :content=>[
    {
      :nodeType=>"heading-3",
      :data=>{},
      :content=>[
        {
          :marks=>[],
          :value=>"hello world",
          :nodeType=>"text",
          :data=>{}
        }
      ]
    }
  ]
}
```

### Additional info

**`<a>`**

* HTML hyperlinks with full URL e.g: (`<a href="https://google.com"></a>`), will be converted into URL hyperlinks
  ```ruby
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
  ```

* HTML hyperlinks without a scheme e.g: (`<a href="/about_us/contact">about us</a>`), will be converted into ENTRY hyperlinks, with the href value as an ID
  ```ruby
  {
    nodeType: "paragraph",
    data: {},
    content: [
      {
        nodeType: "entry-hyperlink",
        data: {
          target: {
            sys: {
              id: "/about_us/contact",
              type: "Link",
              linkType: "Entry"
            }
          }
        },
        content: [
          {
            data: {},
            marks: [],
            value: "about us",
            nodeType: "text"
          }
        ]
      }
    ]
  }
  ```

* HTML hyperlinks without a scheme but with an extension e.g: (`<a href="/path/to_file.docx">file</a>`), will be converted into ASSET hyperlinks, with the href value as an ID, excluding the extension.
  ```ruby
  {
    nodeType: "paragraph",
    data: {},
    content: [
      {
        nodeType: "asset-hyperlink",
        data: {
          target: {
            sys: {
              id: "/path/to_file",
              type: "Link",
              linkType: "Entry"
            }
          }
        },
        content: [
          {
            data: {},
            marks: [],
            value: "file",
            nodeType: "text"
          }
        ]
      }
    ]
  }
  ```

**`<embed />` AND `<img />`**

If you want to add an embedded entry block, you need to create an `<embed>` element in HTML
with src and type attributes, for ID and entry type. Images will be converted into
embedded-asset-blocks by default and the src will be used as an ID.

* Embedded Entry block: `<embed src="id_of_your_entry_123" type="entry"/>`
  ```ruby
    {
      data: {
        target: {
          sys: {
            id: "id_of_your_entry_123",
            type: "Link",
            linkType: "Entry"
          }
        }
      },
      content: [],
      nodeType: "embedded-entry-block"
    }
  ```

* Embedded Asset block: `<embed src="id_of_your_entry_123" type="asset"/>`
  Images: `<img src='id_of_your_entry_123' />`
  ```ruby
    {
      data: {
        target: {
          sys: {
            id: "id_of_your_entry_123",
            type: "Link",
            linkType: "Asset"
          }
        }
      },
      content: [],
      nodeType: "embedded-asset-block"
    }
  ```

---

### Tests
```ruby
# Unit tests
rspec

# Feature tests
rspec ./spec/features/*
```

### Contributions
* Fork it
* Create a branch
* Add your changes and tests
* Submit a PR

### License

Copyright (C) 2019 Alex Avlonitis

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, version 3.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
