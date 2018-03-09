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

end