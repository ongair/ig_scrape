$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "ig_scrape"
require 'webmock/minitest'
require "minitest/autorun"
require "minitest/reporters"

extend MiniTest::Spec::DSL
Minitest::Reporters.use!
