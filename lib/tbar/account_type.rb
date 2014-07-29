require 'tbar/credit'
require 'tbar/debit'
module Tbar
  class AccountType
    class GroupType < AccountType; end

    GROUP     = GroupType.new

    class DebitType < AccountType
      def increasing; Tbar::Credit end
      def decreasing; Tbar::Debit end
      def type; increasing end
    end

    class CreditType < AccountType
      def increasing; Tbar::Debit end
      def decreasing; Tbar::Credit end
      def type; increasing end
    end

    def increasing_entry( kwargs = {} )
      increasing.new( kwargs )
    end

    def decreasing_entry( kwargs = {} )
      decreasing.new( kwargs )
    end

    ASSET     = DebitType.new
    LIABILITY = CreditType.new
    REVENUE   = CreditType.new
    EXPENSE   = DebitType.new
    EQUITY    = CreditType.new

    def self.debits
      [ ASSET, EXPENSE ]
    end

    def self.credits
      [ LIABILITY, REVENUE, EQUITY ]
    end

    def self.all
      debits + credits
    end

  end
end
