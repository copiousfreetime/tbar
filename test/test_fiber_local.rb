require 'test_helper'
require 'tbar/fiber_local'

module Tbar
  class FiberLocalTest < Test
    def setup
      @local = Tbar::FiberLocal.new
    end

    def teardown
      @local.clear
    end

    def test_keys
      assert_equal [], @local.keys
    end

    def test_has_key
      @local['foo'] = "bar"
      assert @local.key?( :foo )
      assert @local.key?( "foo" )
    end

    def test_store
      before = @local.keys.size
      @local[:foo] = "bar"
      assert_equal( (before+1), @local.keys.size )
    end

    def test_fetch
      @local[:foo] = "bar"
      assert_equal "bar", @local[:foo]
    end

    def test_fetch_indifferent_access
      before = @local.keys.size
      @local[:foo] = "bar"
      assert_equal "bar", @local["foo"]
      @local["foo"] = "baz"
      assert_equal "baz", @local[:foo]
      assert_equal( (before+1), @local.keys.size )
    end

    def test_delete
      before = @local.keys.size
      @local[:foo] = "bar"
      assert_equal(before+1, @local.keys.size)
      @local.delete( "foo" )
      assert_equal(before, @local.keys.size)
    end

    def test_clear
      before = @local.keys.size
      @local[:foo] = "bar"
      @local[:baz] = "wibble"
      assert_equal( before+2, @local.keys.size )
      @local.clear
      assert_equal 0, @local.keys.size
      refute @local.key?( :foo )
      refute @local.key?( :baz )
    end
  end
end
 
