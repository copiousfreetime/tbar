require 'tbar/entry'
module Tbar
  class Debit < Entry
    def type
      :debit
    end

    def other_entry
      Tbar::Credit
    end
  end
end
