require "./downmarker"

class Dm < Thor
  
  desc "build IN_PATH OUT_PATH", "Builds an HTML site based on Markdown"
  def build(input_path, output_path)
    Downmarker::Builder.build_site(input_path, output_path)
    
    puts "Your site is now available in #{output_path}"
  end
  
  desc "convert IN_FILE OUT_FILE", "Convert an input Markdown file to an output HTML file"
  def convert(input_file, output_file)
    Downmarker::Converter.convert_file(input_file, output_file)
  end
  
end