StringParser is a simple ruby library for the most common cases or parsing the string,
like converting all urls to links and images, escaping tags and breaking too long words.

== USAGE

  Block notation:

    parser = StringParser.new("<b>Hello, <script></script><i>world!</b>") do |p|
      p.close_tags.html_escape(:except => %w(b i))
      p.break_long_words
      p.urls_to_images.urls_to_links
    end
    parser.string #returns a modified string

  or you could do that without the block:

    StringParser.new("what a cool url: http://url.com<br/>").urls_to_links.html_escape.string

  Note how in both cases method chains were used.
  See rdoc for the list of all available methods.

== REQUIREMENTS

  Should work with Rails 2.x

== INSTALL

  To install as a rails plugin:

    git clone git://github.com/snitko/string_parser.git vendor/plugins/string_parser 

  RubyGem version is coming.
