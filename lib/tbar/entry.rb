module Tbar
  # Private: Entry is one item of a Transaction. It represents one of the
  # Credit or Debit entries in a Transaction. This class is 
  class Entry
    # The Account this posting is for
    attr_reader :account

    # The Amount of the Posting
    attr_reader :amount

    # The Commodity - USD, Stock, etc.
    attr_reader :commodity

    # Additional text to go with this posting
    attr_reader :note

    def self.default_commodity
      @default_commodity ||= :usd
    end

    def self.default_commodity=( com )
      @default_commodity = com
    end

    def initialize( args = {} )
      @account   = args.fetch( :account )
      @amount    = args.fetch( :amount )

      @commodity = args.fetch( :commodity, self.class.default_commodity )
      @note      = args.fetch( :note, nil )
    end

    def type
      raise NotImplementedError, "'type' not defined for Entry. Use Credit or Debit"
    end

  end
end
