module Tbar
  # Publice: Account Group acts as an invisible top level Account for group
  # account trees together.
  #
  # The Account group does not count as part of the depth, or size of the tree.
  # It is an invisible node.
  class AccountGroup < Account
    # Public: Create a new Account Group
    #
    #
    def initialize( kwargs = {} )
      super( kwargs.merge( :type => Tbar::AccountType::GROUP ) )
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
