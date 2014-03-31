require 'test_helper'
require 'tbar/fiber_local'

module Tbar
  class FiberLocalTest < Test
    class Container
      def locals
        @locals ||= Tbar::FiberLocal.new
      end
    end

    def setup
      @local = Tbar::FiberLocal.new
    end

    def teardown
      @local.clear
    end

    def test_keys
      assert_equal [:__recursive_key__], @local.keys
    end

    def test_has_key
      @local['foo'] = "bar"
      assert @local.key?( :foo )
      assert @local.key?( "foo" )
    end

    def test_store
      @local[:foo] = "bar"
      assert_equal 2, @local.keys.size
    end

    def test_fetch
      @local[:foo] = "bar"
      assert_equal "bar", @local[:foo]
    end

    def test_fetch_indifferent_access
      @local[:foo] = "bar"
      assert_equal "bar", @local["foo"]
      @local["foo"] = "baz"
      assert_equal "baz", @local[:foo]
      assert_equal 2, @local.keys.size
    end

    def test_delete
      @local[:foo] = "bar"
      assert_equal 2, @local.keys.size
      @local.delete( "foo" )
      assert_equal 1, @local.keys.size
    end

    def test_clear
      @local[:foo] = "bar"
      @local[:baz] = "wibble"
      assert_equal 3, @local.keys.size
      @local.clear
      assert_equal 1, @local.keys.size
      refute @local.key?( :foo )
      refute @local.key?( :baz )
    end
  end
end
 
