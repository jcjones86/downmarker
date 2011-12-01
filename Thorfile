require "./downmarker"

class DmRunner < Thor
  
  desc "convert IN_FILE OUT_FILE", "Convert an input Markdown file to an output HTML file"
  def convert(input_file, output_file)
    @dm = Downmarker.new
    
    @dm.convert_file(input_file, output_file)
  end
  
end