# Replase test data from spec
require 'rails_helper'

RSpec.describe TexProcessing do
  def read_file(path)
    File.read(File.dirname(__FILE__) + '/../fixtures/' + path)
  end

  it 'easy footnotes' do
      source = read_file('footnotes.simple.txt')
      result = read_file('footnotes.simple.result.txt')

      expect(TexProcessing.footnotes(source)).to eq result
  end

  it 'complex footnotes' do
      source = read_file('footnotes.complex.txt')
      result = read_file('footnotes.complex.result.txt')

      expect(TexProcessing.footnotes(source)).to eq result
  end

  it 'makes fracs' do
      source = 'sample 23/ 24 othe/12'
      result = 'sample \sfrac{23}{24} othe/12'

      expect(TexProcessing.fraction(source)).to eq result
  end

  it 'fixes dots' do
      source = 'table ....... 1 not table.... \n not table 2...'
      result = 'table \dotfil 1 not table\dots \n not table 2\dots'

      expect(TexProcessing.dots(source)).to eq result
  end

  it 'fixes dash in ranges' do
      source = '1*—2 II—X and — mdash'
      result = '1*--2 II--X and — mdash'

      expect(TexProcessing.ndash(source)).to eq result
  end

  it 'removes end break' do
      s1, s2 = "fir-\nst and seco- \n\n", "nd and other"
      r1, r2 = "fir-\nst and second\n", "and other"

      expect(TexProcessing.remove_end(s1, s2)).to eq [r1, r2]
  end

  it 'removes end break' do
    pref = "\\ind\n"

    t1, t2 = "first and seco-\n\n", "nd other"
    r1 = "first and second\n\\ind\nother"
    t3, t4 = "first and second\n\n", "new other"
    r2 = "first and second\n\n\\ind\nnew other"

    expect(TexProcessing.join_text(t1, pref, t2, false)).to eq r1
    expect(TexProcessing.join_text(t3, pref, t4, true)).to eq r2
  end
end