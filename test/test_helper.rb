require 'simplecov'
gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require 'pathname'

module Tbar
  class Test < ::Minitest::Test
    def directory
      Pathname.new( __FILE__ ).dirname
    end

    def data_directory
      directory.join( 'data' )
    end

    def data_file( basename )
      data_directory.join( basename )
    end
  end
end
