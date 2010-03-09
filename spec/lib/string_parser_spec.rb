require File.expand_path(File.dirname(__FILE__) + '/../../spec/spec_helper.rb')

describe StringParser do
  
  it "closes unclosed tags" do
    parser = StringParser.new("<b>Hello,<i>world</b>")
    parser.close_tags.string.should have_text('<b>Hello,<i>world</b></i>')
  end

  it "escapes html except for some of the allowed tags" do
    parser = StringParser.new('<img src="#" style="border: solid 1px green;"><b>Hello</b>')
    parser.html_escape(:except => %w(img)).string.should have_text('<img src="#">&lt;b&gt;Hello&lt;/b&gt;')
  end

  it "makes images of urls that end with .jpg and other image extensions" do
    parser = StringParser.new('Hello, this is my photo http://image.com/image.jpg, yeah baby')
    parser.urls_to_images(:wrap_with => ['<p>', '</p>'], :html_options => 'class="ico"').string.should have_text(
      'Hello, this is my photo<p><img src="http://image.com/image.jpg" alt="" class="ico"/> </p>yeah baby')
  end

  it "makes links of urls" do
    # example 1
    parser = StringParser.new('Hello, this is my homepage http://url.com, yeah baby')
    parser.urls_to_links.string.should have_text(
      'Hello, this is my homepage <a href="http://url.com" >http://url.com</a>, yeah baby')
    
    # example 2
    parser = StringParser.new("http://localhost:3000/\nhttp://localhost:3000/")
    parser.urls_to_links.string.should have_text(
      "<a href=\"http://localhost:3000/\" >http://localhost:3000/</a>\n<a href=\"http://localhost:3000/\" >http://localhost:3000/</a>")

    # example 3
    parser = StringParser.new('http://gyazo.com/a4c16e7a6009f40f29248ad4fed41bd3.png<br>')
    parser.urls_to_links.string.should have_text('<a href="http://gyazo.com/a4c16e7a6009f40f29248ad4fed41bd3.png" >http://gyazo.com/a4c16e7a6009f40f29248ad4fed41bd3.png</a><br>')
  end

  it "highlights code" do
    parser = StringParser.new('<code>print "hello, world!"</code>')
    parser.highlight_code.string.should have_text('<pre class="active4d">print <span class="String"><span class="String">&quot;</span>hello, world!<span class="String">&quot;</span></span>' + "\n</pre>") 
  end

  it "breaks long words" do
    long_string = 'l'; 1.upto(80) { |i| long_string << "o" }; long_string << "ng"
    parser = StringParser.new(long_string)
    # fix extra space at the end of the line
    parser.break_long_words.string.should have_text("looooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo oooooong ")
  end

  it "cuts too long string and appends (if specified) characters to its end" do
    parser = StringParser.new("This is quite a long text")
    parser.cut(11, 7, :append => '...').string.should have_text("This is...")
  end

  it "allows to use block notation" do
    parser = StringParser.new('http://images.com/image.jpg <b>Hello http://url.com </b>') do |p|
      p.urls_to_images.urls_to_links(:html_options => 'target="_blank"')
    end
    parser.string.should have_text(
      "<img src=\"http://images.com/image.jpg\" alt=\"\" /> <b>Hello <a href=\"http://url.com\" target=\"_blank\">http://url.com</a> </b>"
    )
  end



end
