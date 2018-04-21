# Replase test data from spec
require 'rails_helper'

RSpec.describe Joiner do

  it 'removes end break' do
    s1, s2 = "fir-\nst and seco-", "nd and other"
    r1, r2 = "fir-\nst and second", "and other"

    expect(Joiner.remove_end(s1, s2)).to eq [r1, r2]
  end

  it 'removes end break' do
    pref = "\nind\n"

    t1, t2 = "first and seco-", "nd other"
    r1 = "first and second\nind\nother"
    t3, t4 = "first and second", "new other"
    r2 = "first and second\n\nind\nnew other"

    expect(Joiner.join_text(t1, pref, t2, false)).to eq r1
    expect(Joiner.join_text(t3, pref, t4, true)).to eq r2
  end
end