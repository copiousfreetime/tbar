require 'test_helper'
require 'tbar/jaro_winkler'

module Tbar
  # Values taken from the wikipedia entry
  # http://en.wikipedia.org/wiki/Jaro%E2%80%93Winkler_distance#Example
  class JaroWinklerTest < Test

    def setup
      @jaro_scores = [
                       [ "martha", "marhta", "0.944" ],
                       [ "DWAYNE", "DUANE",  "0.822" ],
                       [ "DIXON", "DICKSONX","0.767" ] 
      ]

      @scores = [
                       [ "martha", "marhta", "0.961" ],
                       [ "DWAYNE", "DUANE",  "0.840" ],
                       [ "DIXON", "DICKSONX","0.813" ] 
      ]

    end

    def test_jaro
      @jaro_scores.each do |s1, s2, score|
        jw = Tbar::JaroWinkler.new( s1, s2 )
        value = "%0.3f" % jw.jaro_score
        assert_equal( score, value )
      end
    end

    def test_score
      @scores.each do |s1, s2, score|
        jw = Tbar::JaroWinkler.new( s1, s2 )
        value = "%0.3f" % jw.score
        assert_equal( score, value )
      end
    end
  end
end

