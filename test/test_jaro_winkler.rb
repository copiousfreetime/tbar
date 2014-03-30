require 'test_helper'
require 'tbar/jaro_winkler'

module Tbar
  class JaroWinklerTest < Test

    def setup
      @jaro_scores = [
                       [ "martha", "marhta", "0.944" ],
                       [ "DWAYNE", "DUANE",  "0.822" ],
                       [ "DIXON", "DICKSONX","0.767" ] 
      ]

    end

    def test_jaro
      @jaro_scores.each do |s1, s2, score|
        jw = Tbar::JaroWinkler.new( s1, s2 )
        value = "%0.3f" % jw.jaro_score
        assert_equal( score, value )
      end

    end
  end
end

