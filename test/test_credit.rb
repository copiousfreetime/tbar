require 'test_helper'
require 'tbar/credit'

module Tbar
  class CreditTest< ::Minitest::Test
    def test_is_credit_type
      c = Tbar::Credit.new( :account => "foo", :amount => 123 )
      assert_equal :credit, c.type
    end
  end
end
 
