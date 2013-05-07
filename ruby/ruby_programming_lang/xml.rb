# Example 8-11. A simple DSL for generating XML output

class XML
  # Create an instance of this class, specifying a stream or object to
  # hold the output. This can be any object that responds to <<(String).
  def initialize(out)
    @out = out # Remember where to send our output
  end
  # Output the specified object as CDATA, return nil.
  def content(text)
    @out << text.to_s
    nil
  end
  # Output the specified object as a comment, return nil.
  def comment(text)
    @out << "<!-- #{text} -->"
    nil
  end
  # Output a tag with the specified name and attributes.
  # If there is a block invoke it to output or return content.
  # Return nil.
  def tag(tagname, attributes={})
    # Output the tag name
    @out << "<#{tagname}"
    # Output the attributes
    attributes.each {|attr,value| @out << " #{attr}='#{value}'" }
    if block_given?
      # This block has content
      @out << '>'
      #
      content = yield
      #
      if content
        #
        @out << content.to_s #
      end
      @out << "</#{tagname}>" #
      End the opening tag
      Invoke the block to output or return content
      If any content returned
      Output it as a string
      Close the tag
      else
        # Otherwise, this is an empty tag, so just close it.
        @out << '/>'
      end
      nil # Tags output themselves, so they don't return any content
  end
  # The code below is what changes this from an ordinary class into a DSL.
  # First: any unknown method is treated as the name of a tag.
  alias method_missing tag
  # Second: run a block in a new instance of the class.
  def self.generate(out, &block)
    XML.new(out).instance_eval(&block)
  end
end

# EXAMPLE
def example
  pagetitle = "Test Page for XML.generate"
  XML.generate(STDOUT) do
    html do
      head do
        title { pagetitle }
        comment "This is a test"
      end
      body do
      h1(:style => "font-family:sans-serif") { pagetitle }
      ul :type=>"square" do
      li { Time.now }
      li { RUBY_VERSION }
      end
      end
    end
  end
end

# OUTPUT =>
#
# <html><head>
# <title>Test Page for XML.generate</title>
# <!-- This is a test -->
# </head><body>
# <h1 style='font-family:sans-serif'>Test Page for XML.generate</h1>
# <ul type='square'>
# <li>2007-08-19 16:19:58 -0700</li>
# <li>1.9.0</li>
# </ul></body></html>
