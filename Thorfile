require "./downmarker"

class Dm < Thor
  
  desc "convert IN_FILE OUT_FILE", "Convert an input Markdown file to an output HTML file"
  def convert(input_file, output_file)
    @dm = Downmarker::Builder.new
    
    @dm.convert_file(input_file, output_file)
  end
  
  desc "build IN_PATH OUT_PATH", "Builds an HTML site based on Markdown"
  def build(input_path, output_path)
    @dm = Downmarker::Builder.new
    
    @dm.build_site(input_path, output_path)
    
    puts "Your site is now available in #{output_path}"
  end
  
end