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
  def test_build_site
    TestHelper.output_test do
      Downmarker::Builder.build_site("test/input", "test/output")
      
      in_files = Dir.glob("test/input/**/*.md")
      out_files = Dir.glob("test/output/**/*.html")
      
      # Matching out file for each in file
      in_files.each do |in_file|
        sanitized = in_file.gsub(/input/, "output").gsub(/\.md$/, ".html")
        assert(out_files.index(sanitized) != nil, "#{sanitized} not found")
      end
    end
  end
end


class TestConverter < Test::Unit::TestCase
  def test_convert_file
    TestHelper.output_test do
      Downmarker::Converter.convert_file("test/input/a.md", "test/output/a.html")
      assert_match(/^<h2>/, IO.read("test/output/a.html"))
    end
  end
  
  def test_convert_string
    assert_match(/^<h3>/, Downmarker::Converter.convert_string("### Blah ###"))
  end
end


class TestDirectory < Test::Unit::TestCase
  def setup
    @dir ||= Downmarker::Directory.new("test/input")
  end
  
  def test_clone_to
    TestHelper.output_test do
      @dir.clone_to("test/output")
      
      assert_equal(
        ["test/output/nested"],
        Dir.glob(File.join("test/output", "**", "*"))
      )
    end
  end
  
  def test_get_subdirs
    assert_equal(["nested/"], @dir.get_subdirs)
  end
  
  def test_get_files
    assert_equal(
      ["a.md", "b.md", "nested/c.md", "nested/d.md"],
      @dir.get_files("md")
    )
  end
end
