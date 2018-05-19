module Tbar
  # Internal
  #
  # Use to privide fiber local storage of items. Generally for global
  # configuration / registry items
  #
  class FiberLocal
    def []( key )
      current[key]
    end

    def []=(key, value)
      current[key] = value
    end

    def keys
      current.keys
    end

    def key?( key )
      current.key?(key)
    end

    def delete( key )
      current[key] = nil
    end

    def clear
      current.keys.each do |k|
        delete( k )
      end
    end

    private

    def current
      Thread.current
    end

  end
end
