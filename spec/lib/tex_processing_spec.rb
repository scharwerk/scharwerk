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

  # describe '.footnote?' do
  #   context 'with ordinary paragraph' do
  #     it 'return false' do
  #       paragraph = 'Остання форма, форма С, дає, нарешті, товаровому світові'\
  #                   'загальносуспільну відносну форму вартости тому й остільки,'\
  #                   'що й оскільки всі належні до нього товари, за одним-однісіньким'\
  #                   'винятком, є виключені з загальної еквівалентної форми. Тому'\
  #                   'один товар, полотно, перебуває у формі безпосередньої вимінности'\
  #                   'на всі інші товари, або в безпосередньо суспільній формі, тому'\
  #                   'й остільки, що й оскільки всі інші товари не перебувають у такій'\
  #                   'формі.24'
  #       expect(TexProcessing.footnote?(paragraph)).to eq false
  #     end
  #   end

  #   context 'with footnote paragraphs' do
  #     it 'return true with number' do
  #       # TODO: how to identify footnote thet, started on previous page?
  #       paragraph = '18   У деякому відношенні з людиною справа стоїть так, як із товаром.'\
  #                   'Через те, що вона родиться на світ ані з дзеркалом, ані як фіхтівський'\
  #                   'філософ: «Я є я», то людина спершу видивляється в іншу людину, як у'\
  #                   'дзеркало. Лише через відношення до людини Павла як до подібного до'\
  #                   'себе, людина Петро відноситься й до себе самої як до людини. Але тим'\
  #                   'самим і Павло з шкурою й волоссям, у його Павловій тілесності, стає для'\
  #                   'нього за форму виявлення роду «людина».'
  #       expect(TexProcessing.footnote?(paragraph)).to eq true
  #     end
  #     it 'return true with *' do
  #       paragraph = '* Париж таки вартий служби божої. Ред.'

  #       expect(TexProcessing.footnote?(paragraph)).to eq true
  #     end
  #   end
  #   context 'with heading' do
  #     it 'return false with one digit' do
  #       paragraph = '5. Боротьба за нормальний робочий день'

  #       expect(TexProcessing.footnote?(paragraph)).to eq false
  #     end
  #     it 'return false with two digit' do
  #       paragraph = '11. Боротьба за нормальний робочий день'

  #       expect(TexProcessing.footnote?(paragraph)).to eq false
  #     end
  #   end
  # end
  # describe '.footnotes_array' do
  #   it 'return array of footnote' do
  #     source = read_file('footnotes.simple.txt')
  #     first_footnote = "18    У деякому відношенні з людиною справа стоїть так, як із товаром.\n"\
  #                      "Через те, що вона родиться на світ ані з дзеркалом, ані як фіхтівський\n"\
  #                      "філософ: «Я є я», то людина спершу видивляється в іншу людину, як у\n"\
  #                      "дзеркало. Лише через відношення до людини Павла як до подібного до\n"\
  #                      "себе, людина Петро відноситься й до себе самої як до людини. Але тим\n"\
  #                      "самим і Павло з шкурою й волоссям, у його Павловій тілесності, стає для\n"\
  #                      "нього за форму виявлення роду «людина»."
  #     second_footnote = "* Париж таки вартий служби божої. Ред.\n"

  #     result = [first_footnote, second_footnote]
  #     expect(TexProcessing.footnotes_array(source)).to eq result
  #   end
  # end
  # describe '.collect_footnotes' do
  #   context 'with real text' do
  #     it 'return footnotes part of the text' do
  #       source = read_file('footnotes.complex.txt')

  #       result = read_file('footnotes.complex_clipped.txt')

  #       expect(TexProcessing.collect_footnotes(source)).to eq result
  #     end
  #   end
  #   context 'with a sample text' do
  #     it 'return footnote part of the text' do
  #       source = "Here is text line 0\n"\
  #                "Here is text line 1\n"\
  #                "Here is text line 2\n"\
  #                "24 Here is footnote line 1\n"\
  #                "Here is footnote line 2"
  #       result = "24 Here is footnote line 1\n"\
  #                "Here is footnote line 2"
  #       expect(TexProcessing.collect_footnotes(source)).to eq result
  #     end
  #   end
  # end
  # describe '.first_footnote_index' do
  #   context 'with a sample text' do
  #     it 'return index of first footnote line' do
  #       source = "Here is text line 0\n"\
  #                "Here is text line 1\n"\
  #                "Here is text line 2\n"\
  #                "24 Here is footnote line 1\n"\
  #                "Here is footnote line 2\n"
  #       expect(TexProcessing.first_footnote_index(source)).to eq 3
  #     end
  #   end
  # end

  # describe '.footnote_line?' do
  #   context 'with footnonte line' do
  #     it 'return true' do
  #       line = "18    У деякому відношенні ... стоїть так, як із товаром.\n"\

  #       expect(TexProcessing.footnote_line?(line)).to eq true
  #     end
  #   end
  # end

  describe '.grab_footnote_paragraph' do
  #   context 'with complex text' do
  #     it 'return single footnote' do
  #       source = read_file('footnotes.complex.txt')
  #       result = read_file('footnotes.complex.result.txt')

  #       expect(TexProcessing.footnotes(source)).to eq result

  #     end
  # # end
  #   end
    context 'with a one single line footnote' do
      it 'return single footnote paragraph' do
        source = "Here is text line 0\n"\
                 "Here is text line 1\n"\
                 "Here is text line 2\n"\
                 "24 Here is footnote line 1"
        result = "24 Here is footnote line 1"
        expect(TexProcessing.grab_footnote_paragraph(source)).to eq result
      end
    end
    context 'with a one multiline footnote' do
      it 'return single fotnote' do
        source = "Here is text line 0\n"\
                 "Here is text line 1\n"\
                 "Here is text line 2\n"\
                 "24 Here is footnote line 1\n"\
                 "Here is footnote line 2"
        result = "24 Here is footnote line 1\n"\
                 "Here is footnote line 2"
        expect(TexProcessing.grab_footnote_paragraph(source)).to eq result
      end
    end
    context 'with several multiline footnotes' do
      it 'return single fotnote' do
        source = "Here is text line 0\n"\
                 "Here is text line 1\n"\
                 "Here is text line 2\n"\
                 "24 Here is footnote line 1\n"\
                 "Here is footnote line 2\n"\
                 "* Here is new footnote"
        result = "24 Here is footnote line 1\n"\
                 "Here is footnote line 2"
        expect(TexProcessing.grab_footnote_paragraph(source)).to eq result
      end
    end
  end
end
