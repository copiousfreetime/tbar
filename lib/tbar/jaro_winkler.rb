module Tbar
  # An implementation of the Jaro Winkler - distance
  # http://en.wikipedia.org/wiki/Jaro%E2%80%93Winkler_distance
  #
  # Defaults from original implementation
  # http://www.census.gov/geo/msb/stand/strcmp.c
  class JaroWinkler

    # Private class for origanizing the strings as input
    class Input
      attr_reader :shorter
      attr_reader :longer

      def initialize( s1, s2 )
        @shorter, @longer = ordered( clean(s1), clean(s2) )
      end

      def window_range( idx )
        min = [ idx - window_size, 0 ].max
        max = [ idx + window_size, (longer.length - 1) ].min
        Range.new( min, max )
      end

      def empty?
        shorter.empty? || longer.empty?
      end

      def common_chars( length)
        count = 0
        (0..max_shorter_index(length)).each do |idx|
          if shorter[idx] == longer[idx] then
            count += 1
          else
            break
          end
        end
        return count
      end

      private

      def max_shorter_index( length )
        [length, shorter.length].min - 1
      end


      def clean( s )
        s.to_s.strip.downcase.chars.to_a
      end

      def ordered( s1, s2 )
        s1.length< s2.length ? [ s1, s2 ] : [ s2, s1 ]
      end

      def window_size
        (longer.length / 2) - 1
      end
    end

    # Comparison with above this jaro score will get the winkler boost
    attr_reader :boost_threshold

    # Number of characters to use for winkler boost
    attr_reader :prefix_length

    # multiplicative factor for winkler boost
    attr_reader :prefix_scale

    def self.distance( s1, s2)
      JaroWinkler.new.distance( s1, s1 )
    end


    def initialize( kwargs = {} )
      @boost_threshold = kwargs.fetch( :boost_threshold, 0.7 )
      @prefix_length   = kwargs.fetch( :prefix_length, 4 )
      @prefix_scale    = kwargs.fetch( :prefix_scale, 0.1 )
    end


    # Compute the Jaro Winkler Distance for the two Strings
    #
    # Return a value between 0 and 1
    def distance( s1, s2 )
      input = Input.new( s1, s2 )
      return empty_score( input ) if input.empty?
      score = jaro_distance_internal( input )

      if score > boost_threshold then
        score += winkler_score( input, score )
      end
      return score
    end

    # Computer the Jaro Distance for the two Strings
    #
    # Returns a value between 0 and 1
    def jaro_distance( s1, s2 )
      jaro_distance_internal( Input.new( s1, s2 ) )
    end

    private

    def empty_score( input )
      if input.shorter.empty? then
        if input.longer.empty? then
          return 1.0
        else
          return 0.0
        end
      end
    end

    def jaro_distance_internal( input )
      m = matches( input )
      return 0.0 if m.empty?
      t = transpositions( m )
      mf = Float(m.size)

      ( mf / input.shorter.length +
        mf / input.longer.length +
        (mf - t ) / mf ) / 3
    end

    def winkler_score( input, jaro_distance )
      input.common_chars( prefix_length ) *
        prefix_scale * ( 1 - jaro_distance )
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
    def matches( input )
      matches = Array.new

      input.shorter.each_with_index do |char, idx|
        input.window_range( idx ).each do |widx|
          if input.longer[widx] == char then
            matches << widx
            break
          end
        end
      end

      return matches
    end

  end
end
