require 'test_helper'
require 'tbar/payee'

module Tbar
  class TestPayee < Test
    def setup
      @payee = Tbar::Payee.new( 'payee' )
    end

    def test_stringish
      assert_equal 'payee', "#{@payee}"
    end 
  end
end
