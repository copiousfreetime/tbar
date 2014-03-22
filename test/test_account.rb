require 'test_helper'
require 'tbar/account'

module Tbar
  class AccountTest < ::Minitest::Test
    def test_is_root
      a = Account.new( :name => 'root', :type => Tbar::AccountType::ASSET )
      assert a.root?
    end

    def test_is_leaf
      a = Account.new( :name => 'root', :type => Tbar::AccountType::ASSET )
      l = a.create_child( 'leaf' )
      assert a.root?
      refute a.leaf?
      assert l.leaf?
      refute l.root?
    end

    def test_size
      a = Account.new( :name => 'root', :type => Tbar::AccountType::ASSET )
      a.create_child( 'leaf1' )
      a.create_child( 'leaf2' )
      assert_equal 3, a.size
    end

    def test_depth
      a = Account.new( :name => 'root', :type => Tbar::AccountType::ASSET )
      c1 = a.create_child( 'child1' )
      a.create_child( 'child2' )
      c1.create_child( 'leaf1' )
      assert_equal 3, a.depth
    end

    def test_create_child_tree
      a = Account.new( :name => 'root', :type => Tbar::AccountType::ASSET )
      a.create_child_path( %w[ child grandchild leaf ] )
      assert_equal 4, a.depth
      assert_equal 4, a.size
    end
  end
end
