require 'test_helper'
require 'tbar/chart_of_accounts'

module Tbar
  class ChartOfAccountsTest < Test
    def setup
      @chart = ChartOfAccounts.new
    end

    def test_add_account
      assert_equal 5, @chart.size
      @chart.add_account( 'Expenses:Banking:Service Fee' )
      assert_equal 3, @chart.depth
      assert_equal 7, @chart.size
    end

    def test_load_paths
      assert_equal 5, @chart.size
      @chart.load_paths( data_file( 'chart_of_accounts.dat' ).readlines )
      assert_equal 28, @chart.size
      assert_equal 4, @chart.depth
    end

    def test_alterante_path_separator
      chart = ChartOfAccounts.new( :options => { :path_separator => "/" } )
      assert_equal 5, chart.size
      chart.add_account( 'Expenses/Banking/Service Fee' )
      assert_equal 3, chart.depth
      assert_equal 7, chart.size
    end

    def test_account_by_name
      chart = ChartOfAccounts.new( :options => { :path_separator => "/" } )
      assert_equal 5, chart.size
      chart.add_account( 'Expenses/Banking/Service Fee' )
      assert_equal 3, chart.depth
      assert_equal 7, chart.size
      by_name = chart.accounts_by_name
      assert_equal 8, by_name.size
      assert_instance_of Tbar::Account, by_name['Expenses/Banking/Service Fee']
      assert_instance_of Tbar::Account, by_name['Expenses/Banking']
    end
  end
end
 
