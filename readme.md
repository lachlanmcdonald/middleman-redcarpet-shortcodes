# Shortcodes for Middleman Redcarpet

Adds support for Wordpress-like _Shortcodes_ to [Middleman](http://middlemanapp.com/)'s Redcarpet render.
(__NOTE:__ This is a work in progress. Please see the _Todo_ section below.)

## Installation

Include the contents of [`config.rb`](https://github.com/lachlanmcdonald/middleman-redcarpet-shortcodes/blob/master/config.rb) in your own project's `config.rb` file.

## Usage

Shortcodes are enclosed in double square-brackets (this is to avoid a conflict with the syntax for hyperlinks):

```
[[handle]]
```

- The handle can only contain word-characters: `a-z`, `0-9` or underscores.

Arguments can be passed in property\value pairs, much in the same way as you would with HTML:

```
[[handle property="value"]]
```

- Properties can only contain word-characters: `a-z`, `0-9` or underscores.
- Values must be enclosed in double-quotes
- Values can not contain double-quotes (even if escaped)
- Empty values are allowed, i.e. `property=""`. Properties without values are not allowed.

## Handles

Handles are defined as static methods on the `Shortcodes` class. You can add handles by adding additional static methods to the class.

- Each proprety-value combination is passed as a hash to the first argument.
- All properties are passed as symbols, i.e. `:title` in the sample code below.
- All values are passed as strings
- If there is more than one property with the same name, the property value will instead be an array of strings.

```ruby
class Shortcodes
    def self.del(args)
    	return middleman_app.content_tag(:del, args[:title])
    end

    # rest of the class
end
```

To use in your Markdown document:

```
[[del title="Text marked for deletion"]]
```

Which will output:

```html
<del>Text marked for deletion </del>
```

__Note:__

- Your handle doesn't need to return HTML, it can also return Markdown (which will be processed by Redcarpet).
- Your Middleman application is made available through the `middleman_app` variable, allowing the use of methods like the `content_tag` helper shown in the example above.

## How it works

Middleman extends the Redcarpet Markdown implementation to ensure that images and links defined in your Markdown document are aware of your sitemap. This extension works by supplementing that class with a `preprocess` call to parse your document before it is handled by Redcarpet. After Redcarpet parses your document, the postprocess method applies "Smartypants" module.

## Todo

- Move entire thing into a properly encapsulated module so that it can be loaded as an extension and keep the `config.rb` file tidy.
- Add support for block-level shortcodes (and nestled shortcodes),
  i.e. `[[block]] ... [[/block]]`
- Support escaped double-quotes in property values.
  i.e. `title="Book: \"The Great Gatsby\""`

