require 'test_helper'
require 'tbar'

describe Tbar::VERSION do
  it 'should have a #.#.# format' do
    Tbar::VERSION.must_match( /\A\d+\.\d+\.\d+\Z/ )
    Tbar::VERSION.to_s.must_match( /\A\d+\.\d+\.\d+\Z/ )
  end
end
