require 'tbar/entry'
module Tbar
  class Credit < Entry
    def type
      :credit
    end

    def other_entry
      Tbar::Debit
    end
  end
end
