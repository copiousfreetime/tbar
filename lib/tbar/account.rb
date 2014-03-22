module Tbar
  # Public: An Account represents a single account in the Chart of Accounts. It
  # may have child accounts.
  #
  # Each Account has an AccountType, a name, and possible children. It is also
  # linked to its parent acccount.
  class Account

    attr_reader :type
    attr_reader :name
    attr_reader :children
    attr_reader :parent

    def initialize( kwargs = {} )
      @name     = kwargs.fetch( :name )
      @type     = kwargs.fetch( :type )
      @parent   = kwargs[:parent]
      @children = kwargs.fetch( :children, Array.new )
    end

    # Public: Is the current Account a root account?
    #
    def root?
      parent.nil?
    end

    # Public: Create a new child with the given name.
    #
    # Create a child with the given name. The :type will be inherited from the
    # parent.
    def create_child( name )
      child = Account.new( :name => name, :type => type, :parent => self )
      children << child
      return child
    end

    # Public: Is the current Account a leaf account?
    #
    def leaf?
      children.empty?
    end

    # Public: The Depth of this account
    #
    # Return the tree depth of this account. This is the number of levels of
    # accounts, including this account
    def depth
      children_depth + 1
    end

    # Internal: The maximum depth of all the children
    def children_depth
      leaf? ? 0 : children.map(&:depth).max
    end

    # Public: The number of accounts and sub accounts in this account
    #
    # Returns Number
    def size
      children_size + 1
    end

    # Internal: Return the nuber of accounts in the children
    #
    # Returns Integer
    def children_size
      leaf? ? 0 : children.map(&:size).reduce(:+)
    end

    # Public: Create a top level Asset Account
    def self.assets
      Account.new( :name => 'Assets', :type => AccountType::ASSET )
    end

    # Public: Create a top level Liabilities Account
    def self.liabilities
      Account.new( :name => 'Liabilities', :type => AccountType::LIABILITY )
    end

    # Public: Create a top level Revenue Account
    def self.revenue
      Account.new( :name => 'Revenue', :type => AccountType::REVENUE )
    end

    # Public: Create a top level expenses Account
    def self.expenses
      Account.new( :name => 'Expenses', :type => AccountType::EXPENSE )
    end

    # Public: Create a top level Equity Account
    def self.equity
      Account.new( :name => 'Equity', :type => AccountType::EQUITY)
    end
  end
end
