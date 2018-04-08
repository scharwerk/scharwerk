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
  #
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

  describe '.footnote_line?' do
    context 'with footnonte line' do
      it 'return true' do
        line = "18    У деякому відношенні ... стоїть так, як із товаром.\n"\

        expect(TexProcessing.footnote_line?(line)).to eq true
      end
    end
  end

  describe '.grab_footnote_paragraph' do
    context 'with complex text' do
      it 'return single footnote' do
        source = read_file('footnotes.simple.txt')
        result = read_file('footnotes.simple.grab_footnote.txt')

        expect(TexProcessing.grab_footnote_paragraph(source, 46)).to eq result
      end
    end
  #   end
    context 'with a one single line footnote' do
      it 'return single footnote paragraph' do
        source = "Here is text line 0\n"\
                 "Here is text line 1\n"\
                 "Here is text line 2\n"\
                 "24 Here is footnote line 1"
        result = "24 Here is footnote line 1"
        expect(TexProcessing.grab_footnote_paragraph(source, 3)).to eq result
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
        expect(TexProcessing.grab_footnote_paragraph(source, 3)).to eq result
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
        expect(TexProcessing.grab_footnote_paragraph(source, 3)).to eq result
      end
    end
  end
  describe '.all_footnote_line_numbers' do
    context 'with a sample text' do
      it 'return footnote`s line number array' do
        source = "Here is text line 0\n"\
                   "Here is text line 1\n"\
                   "Here is text line 2\n"\
                   "24 Here is footnote line 1\n"\
                   "Here is footnote line 2\n"\
                   "* Here is new footnote"
        expect(TexProcessing.all_footnote_line_numbers(source)).to eq [3,5]
      end
    end
    context 'with a simple text' do
      it 'return footnote`s line number array' do
        source = read_file('footnotes.simple.txt')

        expect(TexProcessing.all_footnote_line_numbers(source)).to eq [46,54]
      end
    end
    context 'with a coomplex text' do
      it 'return footnote`s and mistakeline number array' do
        # if line starts with number it recognised as footnote
        source = read_file('footnotes.complex.txt')

        expect(TexProcessing.all_footnote_line_numbers(source)).to eq [26, 32, 56, 57]
      end
    end
  end
end
