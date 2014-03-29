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

    def test_alterate_commodity_is_useable_in_entries
      e = Tbar::Entry.new( :account => "bar", :amount => 123, :commodity => :eur )
      assert_equal Money::Currency.find('EUR'), e.commodity
    end

    def test_raises_error_when_type_is_called
      e = Tbar::Entry.new( :account => 'foo', :amount => 123 )
      assert_raises( NotImplementedError ) { e.type }
    end

  end
end
