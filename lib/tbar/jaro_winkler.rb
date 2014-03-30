module Tbar
  # An implementation of the Jaro Winkler - distance
  # http://en.wikipedia.org/wiki/Jaro%E2%80%93Winkler_distance
  class JaroWinkler
    JARO_BOOST_THRESHOLD  = 0.7
    WINKLER_PREFIX_LENGTH = 4
    WINKLER_PREFIX_SCALE  = 0.1

    def self.distance( s1, s2)
      JaroWinkler.new( s1, s1 ).distance
    end

    attr_reader :shorter
    attr_reader :longer

    def initialize( s1, s2 )
      @shorter, @longer = ordered( clean(s1), 
                                   clean(s2) )
    end

    def score
      return 0.0 if shorter.empty?
      score = jaro_score
      if score > JARO_BOOST_THRESHOLD then
        score += winkler_score( score )
      end
      return score
    end

    def jaro_score
      m = matches
      return 0.0 if m.empty?
      t = transpositions( m )
      mf = Float(m.size)

      ( mf / shorter.length + 
        mf / longer.length +
        (mf - t ) / mf ) / 3
    end

    private

    def winkler_score( jaro_score )
      winkler_count * WINKLER_PREFIX_SCALE * (1 - jaro_score)
    end

    def winkler_count
      count = 0
      (0..winkler_max_index).each do |idx|
        if shorter[idx] == longer[idx] then
          count += 1
        else
          break
        end
      end
      return count
    end

    def winkler_max_index
      [WINKLER_PREFIX_LENGTH, shorter.length].min - 1
    end

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
      @search_window_size ||= (longer.length / 2) - 1
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
