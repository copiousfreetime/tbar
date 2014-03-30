module Tbar
  # An implementation of the Jaro Winkler - distance
  # http://en.wikipedia.org/wiki/Jaro%E2%80%93Winkler_distance
  class JaroWinkler
    JARO_BOOST_THRESHOLD  = 0.7
    WINKLER_PREFIX_LENGTH = 4

    def self.distance( s1, s2)
      JaroWinkler.new( s1, s1 ).distance
    end

    attr_reader :shorter
    attr_reader :longer

    def initialize( s1, s2)
      @shorter, @longer = ordered( clean(s1), 
                                   clean(s2) )
    end

    def distance
      return 0.0 if shorter.empty?
      return jaro_score
    end

    def jaro_score
      m = matches
      t = transpositions( m )
      mf = Float(m.size)

      ( mf / shorter.length + 
        mf / longer.length +
        (mf - t ) / mf ) / 3
    end

    private

    # Returns the count of the number of items in m that are out of order.
    def transpositions( m )
      count = 0
      (0...(m.size - 1)).each do |idx|
        item  = m[idx]
        after = m[idx + 1]
        count += 1 if item > after
      end
      return count
    end

    # Return an array containg the indexes into longer of the matching
    # characters in shorter
    def matches
      matches = Array.new
      shorter.each_with_index do |char, idx|
        window_range( idx ).each do |widx|
          if longer[widx] == char then
            matches << widx
            break
          end
        end
      end
      return matches
    end

    def clean( s )
      s.strip.downcase.chars.to_a
    end

    def search_window_size
      @search_window_size ||= longer.length / 2 - 1
    end

    def ordered( s1, s2 )
      s1.length< s2.length ? [ s1, s2 ] : [ s2, s1 ]
    end

    def window_range( idx )
      min = [ idx - search_window_size, 0 ].max
      max = [ idx + search_window_size, (longer.length - 1) ].min
      Range.new( min, max )
    end

  end
end
