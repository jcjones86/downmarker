require "rubygems"
require "rdiscount"
require "fileutils"

class Downmarker
  MD_EXT = "md"
  
  def get_files(root, ext)
    Dir.glob(File.join(root, "**", "*.#{ext}")).map do |p|
      strip_root(p, root)
    end
  end
  
  def get_directories(root)
    get_files(root, MD_EXT).map { |file|
      File.dirname(file)
    }.uniq
  end
  
  def strip_root(path, root)
    path[(root.length + 1)..-1]
  end
  
  def build_site(source, dest)
    clone_dirs(source, dest)
    
    get_files(source, MD_EXT).each do |input_file|
      output_file = input_file.sub(/\.md$/, ".html")
      convert_file("#{source}/#{input_file}", "#{dest}/#{output_file}")
    end
  end
  
  def clone_dirs(source, dest)
    get_directories(source).each do |dir|
      FileUtils.mkdir_p(File.join(dest, dir))
    end
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
