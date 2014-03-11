require 'test_helper'
require 'tbar/entry'

module Tbar
  class EntryTest< ::Minitest::Test
    def test_raises_error_if_account_is_not_specified
      assert_raises(KeyError) { Tbar::Entry.new( :amount => 123 ) }
    end

    def test_raises_error_if_amount_is_not_specified 
      assert_raises(KeyError) { Tbar::Entry.new( :account => "foo" ) }
    end

    def test_default_commodity_is_USD
      assert_equal :usd, Tbar::Entry.default_commodity
    end

    def test_default_commodity_is_used_in_entries
      Tbar::Entry.default_commodity = :euro
      e = Tbar::Entry.new( :account => "bar", :amount => 123 )
      assert_equal  :euro, e.commodity
    end

  end
end
