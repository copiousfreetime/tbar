module Tbar
  class AccountType
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

    ASSET     = DebitType
    LIABILITY = CreditType
    INCOME    = CreditType 
    EXPENSE   = DebitType
    EQUITY    = CreditType

    def self.debits
      [ ASSET, EXPENSE ]
    end

    def self.credits
      [ LIABILITY, INCOME, EQUITY ]
    end

    def self.all
      debits + credits
    end

  end
end
