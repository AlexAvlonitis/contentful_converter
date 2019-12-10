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

### Contributions
* Fork it
* Create a branch
* Add your changes and tests
* Submit a PR

### License

Copyright (C) 2019 Alex Avlonitis

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
