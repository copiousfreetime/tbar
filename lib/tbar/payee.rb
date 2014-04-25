module Tbar
  class Payee
    attr_reader :name
    def initialize( name )
      @name = name
    end

    alias to_str name
    alias to_s name
  end
end
