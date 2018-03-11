# Replase test data from spec
require 'rails_helper'

RSpec.describe TexProcessing do
  def read_file(path)
    File.read(File.dirname(__FILE__) + '/../fixtures/' + path)
  end

  # it 'easy footnotes' do
  #     source = read_file('footnotes.simple.txt')
  #     result = read_file('footnotes.simple.result.txt')

  #     expect(TexProcessing.footnotes(source)).to eq result
  # end

  # it 'complex footnotes' do
  #     source = read_file('footnotes.complex.txt')
  #     result = read_file('footnotes.complex.result.txt')

  #     expect(TexProcessing.footnotes(source)).to eq result
  # end

  describe '.footnote?' do
    context 'with footnote paragraphs' do
      it 'return true with number' do
        paragraph = '18   У деякому відношенні з людиною справа стоїть так, як із товаром.'\
                    'Через те, що вона родиться на світ ані з дзеркалом, ані як фіхтівський'\
                    'філософ: «Я є я», то людина спершу видивляється в іншу людину, як у'\
                    'дзеркало. Лише через відношення до людини Павла як до подібного до'\
                    'себе, людина Петро відноситься й до себе самої як до людини. Але тим'\
                    'самим і Павло з шкурою й волоссям, у його Павловій тілесності, стає для'\
                    'нього за форму виявлення роду «людина».'
        expect(TexProcessing.footnote?(paragraph)).to eq true
      end
      it 'return true with *' do
        paragraph = '* Париж таки вартий служби божої. Ред.'

        expect(TexProcessing.footnote?(paragraph)).to eq true
      end
    end
  end
end
