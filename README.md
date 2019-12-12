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
**HREF links**

* HTML hyperlinks with full URL e.g: (https://google.com), will be converted into URL hyperlinks

* HTML hyperlinks without a scheme e.g: ('/aboutus/contact'), will be converted into ENTRY hyperlinks, with the href value as an ID

* HTML hyperlinks without a scheme but with an extension e.g: ('myfile.docx'), will be converted into ASSET hyperlinks, with the href value as an ID, minus the extension.

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
