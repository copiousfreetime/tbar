module Tbar
  # Publice: Account Group acts as an invisible top level Account for group
  # account trees together.
  #
  # The Account group does not count as part of the depth, or size of the tree.
  # It is an invisible node.
  #
  # You cannot create direct children to an Account Group, you can only attach
  # Accounts to it or use add_child.
  class AccountGroup < Account
    # Public: Create a new Account Group
    #
    #
    def initialize( kwargs = {} )
      super( kwargs.merge( :type => Tbar::AccountType::GROUP ) )
    end

    def create_child( name )
      raise NotImplementedError, "Unable to create a child to an AccountGroup, please use add_child(String) or attach_child(Account)"
    end

    protected

    def my_depth
      0
    end

    def my_size
      0
    end
  end
end
