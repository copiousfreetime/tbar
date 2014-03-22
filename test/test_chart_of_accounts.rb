require 'test_helper'
require 'tbar/chart_of_accounts'

module Tbar
  class ChartOfAccountsTest < ::Minitest::Test
    def setup
      @chart = ChartOfAccounts.new
    end

    def test_add_account
      assert_equal 5, @chart.size
      @chart.add_account( 'Expenses/Banking/Service Fee' )
      assert_equal 3, @chart.depth
      assert_equal 7, @chart.size
    end
  end
end
 
