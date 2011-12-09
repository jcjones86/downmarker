require "rubygems"
require "rdiscount"
require "fileutils"

module Downmarker
  class Builder
    def self.build_site(source, dest)
      source_dir = Directory.new(source)
      
      source_dir.clone_to(dest)
      source_dir.get_files("md").each do |input_file|
        output_file = input_file.sub(/\.md$/, ".html")
        Converter.convert_file(
          File.join(source, input_file),
          File.join(dest, output_file)
        )
      end
    end
  end
  
  
  class Converter
    def self.convert_file(in_file, out_file)
      input = IO.read(in_file)
      converted = convert_string(input)
      File.open(out_file, "w") { |f| f.write(converted) }
    end
    
    def self.convert_string(input)
      Markdown.new(input).to_html
    end
  end
  
  
  class Directory
    def initialize(path)
      @path = path
    end
    
    def clone_to(dest)
      get_subdirs.each do |subdir|
        FileUtils.mkdir_p(File.join(dest, subdir))
      end
    end
    
    def get_subdirs
      subdirs = Dir.glob(File.join(@path, "**/*/")).select { |path|
        File.directory?(path)
      }
      
      subdirs.map { |d| strip_root(d) }.uniq
    end
    
    def get_files(ext)
      files = Dir.glob(File.join(@path, "**/*.#{ext}"))
      files.map { |path| strip_root(path) }
    end
    
    def strip_root(path)
      path[(@path.length + 1)..-1]
    end
  end
end
