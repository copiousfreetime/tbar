require 'tbar/account'
require 'tbar/account_type'
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
      { :path_separator => "/" }
    end

    attr_reader :groups
    attr_reader :options

    # Public: Create a new Chart of Accounts
    #
    # groups - the list of top level groups required to start the chart.
    #          by default this is ChartOfAccounts.default_groups
    # options - the configuration options for the Chart of Accounts
    def initialize( kwargs = {} )
      @groups  = kwargs.fetch( :groups, ChartOfAccounts.default_groups )
      @options = kwargs.fetch( :options, ChartOfAccounts.default_options )
    end

    # Public: Add a new account with the given path.
    #
    # path - the String path of the account from the top level group to the
    #        final account name. The components of the path are separated by
    #        the `path_separator` string.
    def add_account( path )
      add_account_component( path.split( path_separator ) )
    end


    # Public: The number of Accounts in the chart
    def size
      groups.map(&:size).reduce(:+)
    end

    # Internal:
    #
    # Access the path_separator option
    def path_separator
      options[:path_separator]
    end
  end
end
