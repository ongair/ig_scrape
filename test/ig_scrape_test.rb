require "test_helper"

class IgScrapeTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::IGScrape::VERSION
  end
  
end
