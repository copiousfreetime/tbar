require 'tbar/fiber_local'
module Tbar
  VERSION = "1.0.0"

  module_function

  def config( new_fiber_local = FiberLocal.new )
    @config ||= new_fiber_local
  end

end
require 'tbar/errors'
require 'tbar/account_type'
require 'tbar/account'
require 'tbar/account_group'
require 'tbar/entry'
require 'tbar/credit'
require 'tbar/debit'
require 'tbar/transaction'
require 'tbar/chart_of_accounts'
