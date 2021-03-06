require 'tbar/errors'
require 'tbar/debit'
require 'tbar/credit'
module Tbar
  # Public: Transation represents all the data about moving an amount from one
  # account to another.
  #
  # A Transaction must have at least 1 debit and 1 credit entry, and the sum of
  # the ammounts of the credits and the amount of the ammounts of the credits must
  # be equal.
  class Transaction
    class InvalidTransactionError < ::Tbar::Error; end

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
    # :entries - An array of entries
    # :note    - A note to put with the transaction
    # :payee   - The external entity that is 
    def initialize( kwargs = {} )
      entries  = kwargs.fetch( :entries, [] ).group_by { |e| e.type }
      @credits = [ kwargs[:credits], kwargs[:credit], entries[:credit] ].flatten.compact
      @debits  = [ kwargs[:debits],  kwargs[:debit],  entries[:debit]  ].flatten.compact
      @date    = kwargs.fetch( :date, Date.today )
      @note    = kwargs.fetch( :note, "" )
      @payee   = kwargs.fetch( :payee, "" )
    end

    # Public: Sum all the Credits in the transaction
    def credit_amount
      sum( credits )
    end

    # Public: Sum all the debits in the transaction
    def debit_amount
      sum( debits )
    end

    # Public: validate the transaction, raising InvalidTransactionError if it is
    # not valid
    def valid!
      raise InvalidTransactionError, "Must have at least 1 debit and 1 credit entry" if credits.empty? || debits.empty?
      raise InvalidTransactionError, "Credits (#{credit_amount}) and Debit(#{debit_amount}) must be equivalent" unless credit_amount == debit_amount
    end

    # Public: return true or false based upon the validity of the Transaction
    def valid?
      valid!
      return true
    rescue InvalidTransactionError
      return false
    end

    # Public: Add an entry
    def add_entry( entry )
      case entry
      when Credit
        credits << entry
      when Debit
        debits << entry
      else
        raise ArgumentError, "Transaction is unable to handle an Unknown type: #{entry}"
      end
    end

    def entries
      [credits, debits ].flatten
    end

    def to_s
      lines =  [ "#{date} #{payee}" ]
      credits.each do |credit|
        lines << "    C #{credit.amount} #{credit.account.expand_name.join(':')} -- #{credit.note}"
      end
      debits.each do |debit|
        lines << "    D #{debit.amount} #{debit.account.expand_name.join(':')} -- #{debit.note}"
      end
      lines.join("\n")
    end

    private

    def sum( entry_list )
      entry_list.reduce(Money.empty) { |memo, entry| memo += entry.amount }
    end

  end
end
