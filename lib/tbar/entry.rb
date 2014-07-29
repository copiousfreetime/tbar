require 'money'
module Tbar
  # Private: Entry is one item of a Transaction. It represents one of the
  # Credit or Debit entries in a Transaction. The Entry should never be
  # instantiated directly. It should be instantiated as either a Credit or
  # Debit.
  class Entry
    # The Account this entry is for
    attr_reader :account

    # The Amount of the entry, this must be a Money object, or something that
    # may be converted to a Money object
    attr_reader :amount

    # Additional text to go with this entry
    attr_reader :note

    def initialize( kwargs = {} )
      @account   = kwargs.fetch( :account )
      amt        = kwargs.fetch( :amount )
      commodity  = kwargs.fetch( :commodity, Money.default_currency)
      @amount    = ::Money.new( amt, commodity )
      @note      = kwargs.fetch( :note, nil )
    end

    def commodity
      amount.currency
    end

    def type
      raise NotImplementedError, "'type' not defined for Entry. Use Credit or Debit"
    end

    def other_entry
      raise NotImplementedError, "'other_entry' not defind for Entry. Use Credit or Debit"
    end

    def to_s
      "#<#{self.class.name} #{object_id} name:#{self.account.name} type:#{type} amount:#{amount}>"
    end
  end
end
