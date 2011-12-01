require "rubygems"
require "rdiscount"

class Downmarker
  FILE_GLOB = "**/*.md"
  
  attr_accessor :in_dir
  
  def initialize(in_dir=nil)
    @in_dir = in_dir
  end
  
  def get_files
    Dir.glob("#{@in_dir}/#{FILE_GLOB}")
  end
  
  def convert_file(in_file, out_file)
    input = IO.read(in_file)
    converted = convert_string(input)
    File.open(out_file, "w") { |f| f.write(converted) }
  end
  
  def convert_string(str)
    Markdown.new(str).to_html
  end
end
