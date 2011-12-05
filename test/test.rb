gem "minitest"

require "./downmarker"
require "fileutils"
require "test/unit"
require "turn"


class TestDownmarker < Test::Unit::TestCase
  
  attr_accessor :dm
  
  def setup
    @dm = Downmarker.new
  end
  
  def output_test
    Dir.mkdir("test/output")
    yield
    FileUtils.rm_rf("test/output")
  end
  
  
  def test_get_files
    assert_equal(
      ["a.md", "b.md", "nested/c.md", "nested/d.md"],
      @dm.get_files("test/input", "md")
    )
  end
  
  def test_strip_root
    assert_equal(
      "nested/c.md",
      @dm.strip_root("test/input/nested/c.md", "test/input")
    )
  end
  
  def test_build_site
    output_test do
      @dm.build_site("test/input", "test/output")
    
      in_files = Dir.glob("test/input/**/*.md")
      out_files = Dir.glob("test/output/**/*.html")
    
      # Matching out file for each in file
      in_files.each do |in_file|
        sanitized = in_file.gsub(/input/, "output").gsub(/\.md$/, ".html")
        assert(out_files.index(sanitized) != nil, "#{sanitized} not found")
      end
    end
  end
  
  def test_clone_dirs
    output_test do
      @dm.clone_dirs("test/input", "test/output")
    end
  end
  
  def test_convert_file
    output_test do
      @dm.convert_file("test/input/a.md", "test/output/a.html")
      assert_match(/^<h2>/, IO.read("test/output/a.html"))
    end
  end
  
  def test_convert_string
    assert_match(/^<h3>/, @dm.convert_string("### Blah ###"))
  end
  
end
