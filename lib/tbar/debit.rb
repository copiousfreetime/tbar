require 'tbar/entry'
module Tbar
  class Debit < Entry
    def type
      :debit
    end
  end
end
