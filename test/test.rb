gem "minitest"

require "./downmarker"
require "test/unit"
require "turn"


class TestDownmarker < Test::Unit::TestCase
  
  attr_accessor :dm
  
  def setup
    @dm = Downmarker.new("test/input")
  end
  
  def test_get_files
    assert_equal([
      "test/input/a.md",
      "test/input/b.md",
      "test/input/nested/c.md",
      "test/input/nested/d.md"
    ], @dm.get_files)
  end
  
  def test_convert_file
    @dm.convert_file("test/input/a.md", "test/output/a.html")
    assert_match(/^<h2>/, IO.read("test/output/a.html"))
    File.delete("test/output/a.html")
  end
  
  def test_convert_string
    assert_match(/^<h3>/, @dm.convert_string("### Blah ###"))
  end
  
end
