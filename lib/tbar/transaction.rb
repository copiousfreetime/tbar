require 'tbar/errors'
module Tbar
  # Public: Transation represents all the data about moving a an amount from one
  # account to another. 
  #
  # A Transaction must have at least 1 debit and 1 credit entry, and the sum of
  # the ammounts of the credits and the sum of the ammounts of the credits must
  # be equal.
  class Transaction

    attr_reader :date
    attr_reader :payee
    attr_reader :note
    attr_reader :credits
    attr_reader :debits

    # Create a new Transaction.
    #
    # :credits - An array of Credit's
    # :credit  - A Single Credit
    # :debits  - An array of Debits
    # :debit   - A single Debit
    # :date    - The date of the transaction, defaults to today
    # :note    - A note to put with the transaction
    # :payee   - The external entity that is 
    def initialize( kwargs = {} )
      @credits = [ kwargs[:credits], kwargs[:credit] ].flatten.compact
      @debits  = [ kwargs[:debits],  kwargs[:debit]  ].flatten.compact
      @date    = kwargs.fetch( :date, Date.today )
      @note    = kwargs.fetch( :note, "" )
      @payee   = kwargs.fetch( :payee, "" )
    end

    # Public: validate the transaction, raising InvalidTransactionError if it is
    # not valid
    def valid!
      raise InvalidTransactionError, "Must have at least 1 debit and 1 credit entry" if credits.empty? || debits.empty?
      raise InvalidTransactionError, "Credits (#{credit_sum}) and Debit(#{debit_sum}) must be equivalent" unless credit_sum == debit_sum
    end

    # Public: return true or false based upon the validity of the Transaction
    def valid?
      valid!
      return true
    rescue InvalidTransactionError
      return false
    end

  end
end
