require 'test_helper'
require 'tbar/jaro_winkler'

module Tbar
  # Test vectors taken from:
  # * http://en.wikipedia.org/wiki/Jaro%E2%80%93Winkler_distance#Example
  # * http://www.census.gov/srd/papers/pdf/rrs2006-02.pdf
  # * http://alias-i.com/lingpipe/docs/api/com/aliasi/spell/JaroWinklerDistance.html
  class JaroWinklerTest < Test

    def setup
      @scores = [
        #   String1     String2     Jaro  Winkler
        %w[ FOO         BAR         0.000 0.000 ],

        # * http://alias-i.com/lingpipe/docs/api/com/aliasi/spell/JaroWinklerDistance.html
        %w[ AL          AL          1.000 1.000 ],
        %w[ ABCVWXYZ    CABVWXYZ    0.958 0.958 ],

        # * http://en.wikipedia.org/wiki/Jaro%E2%80%93Winkler_distance#Example
        %w[ DIXON       DICKSONX    0.767 0.813 ],

        # * http://www.census.gov/srd/papers/pdf/rrs2006-02.pdf
        %w[ ABROMS      ABRAMS      0.889 0.922 ],
        %w[ DUNNINGHAM  CUNNIGHAM   0.896 0.896 ],
        %w[ DWAYNE      DUANE       0.822 0.840 ],

        %w[ JERALDINE   GERALDINE   0.926 0.926 ],
        %w[ JON         JOHN        0.917 0.933 ],
        %w[ JONES       JOHNSON     0.790 0.832 ],
        %w[ JULIES      JULIUS      0.889 0.933 ],
        %w[ MARHTA      MARTHA      0.944 0.961 ],
        %w[ MASSEY      MASSIE      0.889 0.933 ],
        %w[ MICHELLE    MICHAEL     0.869 0.921 ],
        %w[ NICHLESON   NICHULSON   0.926 0.956 ],
        %w[ SEAN        SUSAN       0.783 0.805 ],
        %w[ SHACKLEFORD SHACKELFORD 0.970 0.982 ],
        %w[ TANYA       TONYA       0.867 0.880 ],

        # These 3 look wrong in the paper, they says 0.000
        # %w[ HARDIN      MARTINEZ    0.000 0.000 ],
        # %w[ ITMAN       SMITH       0.000 0.000 ],
        # %w[ JON         JAN         0.000 0.000 ],

        %w[ HARDIN      MARTINEZ    0.722 0.722 ],
        %w[ ITMAN       SMITH       0.467 0.467 ],
        %w[ JON         JAN         0.778 0.800 ],

      ]

      @jw = JaroWinkler.new
    end

    def test_jaro
      @scores.each do |s1, s2, j_score, w_score|
        value = "%0.3f" % @jw.jaro_distance( s1, s2 )
        assert_equal( j_score, value, "Failure scoring #{s1} with #{s2}" )
      end
    end

    def test_score
      @scores.each do |s1, s2, j_score, w_score|
        value = "%0.3f" % @jw.distance( s1, s2 )
        assert_equal( w_score, value, "Failure scoring #{s1} with #{s2}" )
      end
    end
  end
end

