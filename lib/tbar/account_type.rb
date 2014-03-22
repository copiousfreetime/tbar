module Tbar
  class AccountType
    class GroupType < AccountType; end

    GROUP     = GroupType.new

    class DebitType < AccountType
      def increasing; :credit end
      def decreasing; :dedit end
      def type; increasing; end
    end

    class CreditType < AccountType
      def increasing; :dedit end
      def decreasing; :credit end
      def type; increasing; end
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
