require 'tbar/account_type'
module Tbar
  # Public: An Account represents a single account in the Chart of Accounts. It
  # may have child accounts.
  #
  # Each Account has an AccountType, a name, and possible children. It is also
  # linked to its parent acccount.
  class Account

    attr_reader   :type
    attr_reader   :name
    attr_reader   :children
    attr_accessor :parent

    def initialize( kwargs = {} )
      @name     = kwargs.fetch( :name )
      @type     = kwargs.fetch( :type )
      @parent   = kwargs[:parent]
      @children = kwargs.fetch( :children, Array.new )
    end

    # Public: equivalence
    #
    # Two accounts are considered equivalent if their names and types are the
    # same.
    def ==(other)
      (other.name == name) && (other.type == type)
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
      account = build_child( name )
      attach_child( account )
      return account
    end

    # Public: Adds a new child with the given name. If a child with that given
    # name already exists in children, then return that child instead.
    #
    def add_child( name )
      if existing = children.find { |child| child.name == name } then
        return existing
      else
        return create_child( name )
      end
    end

    # Public: Attaches the given Account as a child of this Account
    #
    # account - an instance of Account that will attached as a child of this
    #           account
    def attach_child( account )
      account.parent = self
      children << account
    end

    # Public: Return an new account that would be a child account but is not one
    #         of the children yet
    def build_child( name )
      Account.new( :name => name, :type => type, :parent => self )
    end

    # Public: Add a child path of accounts.
    #
    # Create a lineage of accounts, below this account, it will merge it with
    # the existing accounts
    #
    # names - an array of names, each name is the account name of that path
    #         componenet
    #
    # Example:
    #   expenses = Account.expenses
    #   expenses.add_child_path( [ 'Banking', 'Service Fee' ] )
    #
    # Returns nothing
    def add_child_path( names )
      components = names.dup
      parent     = self

      loop do
        break if components.empty?
        child  = components.shift
        parent = parent.add_child( child )
      end
      return parent
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
      children_depth + my_depth
    end

    # Internal: The maximum depth of all the children
    def children_depth
      leaf? ? 0 : children.map(&:depth).max
    end

    # Public: The number of accounts and sub accounts in this account
    #
    # Returns Number
    def size
      children_size + my_size
    end

    # Internal: Return the nuber of accounts in the children
    #
    # Returns Integer
    def children_size
      leaf? ? 0 : children.map(&:size).reduce(:+)
    end

    # Public: expand the name of the Account
    #
    # expand the name to be an array of all the anems in this account and all of
    # its parent accounts
    def expand_name
      return [ name ] if root?
      return parent.expand_name.push( name )
    end

    # Public: return the account tree as an array of Accounts
    #
    def to_array
      children.each_with_object( [ self ] ) { |child, memo|
        memo.concat( child.to_array )
      }.flatten
    end

    def to_s
      "#<#{self.class.name} #{object_id} name:#{self.name} type:#{type} children:#{children.size} >"
    end

    protected

    # Internal
    #
    # The amount this node adds to the size calculation
    def my_size
      1
    end

    # Internal
    #
    # The amount this node adds to the depth calculation
    def my_depth
      1
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
