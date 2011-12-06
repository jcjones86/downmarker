gem "minitest"

require "./downmarker"
require "fileutils"
require "test/unit"
require "turn"

class TestHelper
  def self.output_test
    FileUtils.rm_rf("test/output")
    Dir.mkdir("test/output")
    yield
    FileUtils.rm_rf("test/output")
  end
end


class TestBuilder < Test::Unit::TestCase  
  def setup
    @builder ||= Downmarker::Builder.new
  end
  
  def output_test
    FileUtils.rm_rf("test/output")
    Dir.mkdir("test/output")
    yield
    FileUtils.rm_rf("test/output")
  end

  def test_build_site
    TestHelper.output_test do
      @builder.build_site("test/input", "test/output")
      
      in_files = Dir.glob("test/input/**/*.md")
      out_files = Dir.glob("test/output/**/*.html")
      
      # Matching out file for each in file
      in_files.each do |in_file|
        sanitized = in_file.gsub(/input/, "output").gsub(/\.md$/, ".html")
        assert(out_files.index(sanitized) != nil, "#{sanitized} not found")
      end
    end
  end
  
  def test_convert_file
    TestHelper.output_test do
      @builder.convert_file("test/input/a.md", "test/output/a.html")
      assert_match(/^<h2>/, IO.read("test/output/a.html"))
    end
  end
  
  def test_convert_string
    assert_match(/^<h3>/, @builder.convert_string("### Blah ###"))
  end
end


class TestFileHandler < Test::Unit::TestCase
  def setup
    @file_handler ||= Downmarker::FileHandler.new
  end
  
  def test_get_files
    assert_equal(
      ["a.md", "b.md", "nested/c.md", "nested/d.md"],
      @file_handler.get_files("test/input", "md")
    )
  end
  
  def test_strip_root
    assert_equal(
      "nested/c.md",
      @file_handler.strip_root("test/input/nested/c.md", "test/input")
    )
  end
  
  def test_clone_dirs
    TestHelper.output_test do
      @file_handler.clone_dirs("test/input", "test/output")
    end
  end  
end

