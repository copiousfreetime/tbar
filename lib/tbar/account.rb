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

  end
end
