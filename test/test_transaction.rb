require 'test_helper'
require 'tbar/transaction'

module Tbar
  class TransactionTest < ::Minitest::Test
    def setup
      @debit   = Debit.new( :account => :foo, :amount => "$1.23" )
      @credit  = Credit .new( :account => :foo, :amount => "$1.23" )
      @credits = [ 111, 222, 333 ].map { |x| Credit.new( :account => "#{x}", :amount => x ) }
      @debits  = [ 111, 222, 333 ].map { |x| Debit.new( :account => "#{x}", :amount => x ) }
    end

    def test_validty_requires_debit
      t = Tbar::Transaction.new( :debit => @debit )
      refute t.valid?
    end

    def test_validty_requires_credit
      t = Tbar::Transaction.new( :credit => @credit )
      refute t.valid?
    end

    def test_validity_requires_debit_and_credit_with_equal_amounts
      t = Tbar::Transaction.new( :credit => @credit , :debit => @debit )
      assert t.valid?
    end

    def test_sums_credits
      t = Tbar::Transaction.new( :credits => @credits )
      assert_equal 666, t.credit_amount.cents
      assert_equal Money.new( 666 ), t.credit_amount
    end

    def test_sums_debits
      t = Tbar::Transaction.new( :debits => @debits )
      assert_equal 666, t.debit_amount.cents
      assert_equal Money.new(666), t.debit_amount
    end

    def test_validity_from_entries
      t = Tbar::Transaction.new( :entries => [ @credits, @debits ].flatten )
      assert t.valid?
    end

  end
end
