module Tbar
  # Private: Entry is one item of a Transaction. It represents one of the
  # Credit or Debit entries in a Transaction.
  class Entry
    # The Account this posting is for
    attr_reader :account

    # The Amount of the Posting, this must be a whole number
    attr_reader :amount

    # The Commodity - USD, ticker symbol, etc.
    attr_reader :commodity

    # Additional text to go with this posting
    attr_reader :note

    def self.default_commodity
      @default_commodity ||= :usd
    end

    def self.default_commodity=( com )
      @default_commodity = com
    end

    def initialize( kwargs = {} )
      @account   = kwargs.fetch( :account )
      @amount    = kwargs.fetch( :amount )

      @commodity = kwargs.fetch( :commodity, self.class.default_commodity )
      @note      = kwargs.fetch( :note, nil )
    end

    def type
      raise NotImplementedError, "'type' not defined for Entry. Use Credit or Debit"
    end

  end
end
