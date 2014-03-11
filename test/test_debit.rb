require 'test_helper'
require 'tbar/debit'

module Tbar
  class DebitTest< ::Minitest::Test
    def test_is_dedit_type
      c = Tbar::Debit.new( :account => "foo", :amount => 123 )
      assert_equal :debit, c.type
    end
  end
end
 
