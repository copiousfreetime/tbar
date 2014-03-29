require 'money'
module Tbar
  # Private: Entry is one item of a Transaction. It represents one of the
  # Credit or Debit entries in a Transaction.
  class Entry
    # The Account this posting is for
    attr_reader :account

    # The Amount of the Posting, this must be a Money object, or something that
    # may be converted to a Money object
    attr_reader :amount

    # Additional text to go with this posting
    attr_reader :note

    def initialize( kwargs = {} )
      @account   = kwargs.fetch( :account )
      amt        = kwargs.fetch( :amount )
      commodity  = kwargs.fetch( :commodity, nil )
      @amount    = ::Money.new( amt, commodity || Money.default_currency )
      @note      = kwargs.fetch( :note, nil )
    end

    def commodity
      amount.currency
    end

    def type
      raise NotImplementedError, "'type' not defined for Entry. Use Credit or Debit"
    end

  end
end
