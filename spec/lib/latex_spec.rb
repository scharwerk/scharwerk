# Replase test data from spec
require 'rails_helper'

RSpec.describe Latex do
  it 'converts pdf to pngs' do
    source = File.join(File.dirname(__FILE__), '/../fixtures/', 'sample.pdf')

    Dir.mktmpdir do |path|
      out = File.join(path, 'out')
      Latex.pdf_to_png(source, out)

      expect(File.exist?(path + '/out-1.png')).to be true
      expect(File.exist?(path + '/out-2.png')).to be true
    end
  end
end
