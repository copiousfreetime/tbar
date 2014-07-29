require 'tbar/account'
require 'tbar/account_type'
require 'tbar/account_group'
module Tbar
  # Public: The container holding the entire chart of accounts
  #
  # The ChartOfAccounts is the top level container holding all the accounts for
  # the system. There are a number of top level group accounts which are
  # required to get started.
  #
  class ChartOfAccounts
    # Public:
    #
    # The list of top level group of accounts used by default.
    def self.default_groups
      [ Account.assets, Account.expenses,
        Account.liabilities, Account.revenue, Account.equity ]
    end

    # Public:
    #
    # A set of default options for processing account information
    #
    # path_separator : the string used to separate an Account Path into its
    #                  components
    def self.default_options
      { :path_separator => ":" }
    end

    # Internal
    attr_reader :chart

    # Internal
    attr_reader :options

    # Public: Create a new Chart of Accounts
    #
    # groups - the list of top level groups required to start the chart.
    #          by default this is ChartOfAccounts.default_groups
    # options - the configuration options for the Chart of Accounts
    def initialize( kwargs = {} )
      groups     = kwargs.fetch( :groups, ChartOfAccounts.default_groups )
      @chart     = AccountGroup.new( :name => 'Chart of Accounts', :children => groups )
      @options   = kwargs.fetch( :options, ChartOfAccounts.default_options )
    end

    # Public: Bulk load a list of path into the Chart of Accounts
    #
    # paths - an array of strings suibable for passing into add_account
    #
    # Returns nothing
    def load_paths( paths = [] )
      paths.each do |path|
        add_account( path )
      end
    end

    # Public: Add a new account with the given path.
    #
    # path - the String path of the account from the top level group to the
    #        final account name. The components of the path are separated by
    #        the `path_separator` string.
    def add_account( path )
      chart.add_child_path( path.split( path_separator ) )
    end

    # Public: The number of Accounts in the chart
    def size
      chart.size
    end

    # Public: The depth of the Account tree in the chart
    def depth
      chart.depth
    end

    # Public: Convert the Chart to an Array of Accounts
    #
    def to_array
      chart.to_array
    end

    # Public: Create a hash of the account names to the account objects
    def accounts_by_name
      to_array.each_with_object( {} ) do |account, h|
        real_name = account.expand_name.join( path_separator )
        h[real_name] = account
      end
    end

    # Internal:
    #
    # Access the path_separator option
    def path_separator
      options[:path_separator]
    end
  end
end
