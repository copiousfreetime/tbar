require 'test_helper'
require 'tbar/account_type'

module Tbar
  class TestAccountType < ::Minitest::Test
    def test_5_account_types
      assert_equal 5, AccountType.all.size
    end

    def test_2_debit_types
      assert_equal 2, AccountType.debits.size
    end
    
    def test_3_debit_types
      assert_equal 3, AccountType.credits.size
    end
  end
end
