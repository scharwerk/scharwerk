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

  describe '.footnotes' do
    context 'with a sample text and one footnote' do
      it 'insert footnote in proper places' do
        source = "Here is text line nil\n"\
                 "Here is text 24 line one\n"\
                 "Here is text line two\n"\
                 "\n"\
                 "24 Here is footnote line 1\n"\
                 "Here is footnote line 2"

        result = "Here is text line nil\n"\
                 "Here is text \\footnote{\n"\
                 "Here is footnote line 1\n"\
                 "Here is footnote line 2}\n"\
                 "line one\n"\
                 "Here is text line two\n"
        expect(TexProcessing.footnotes(source)).to eq result
      end
    end

    context 'with a sample text and several footnotes' do
      it 'insert footnote in proper places' do
        source = "Here is text* line nil\n"\
                 "Here is text 24 line one\n"\
                 "Here is text line two\n"\
                 "\n"\
                 "24 Here is footnote line 1\n"\
                 "Here is footnote line 2\n"\
                 "\n"\
                 "* Here is second footnote"

        result = "Here is text\\footnote*{\nHere is second footnote}\nline nil\n"\
                 "Here is text \\footnote{\n"\
                 "Here is footnote line 1\n"\
                 "Here is footnote line 2\n}\n"\
                 "line one\n"\
                 "Here is text line two\n"
        expect(TexProcessing.footnotes(source)).to eq result
      end
    end

    context 'with a real text' do
      it 'insert footnote in proper places' do
        source = "valer, valoir, висловлює, що порівняння товару В з товаром А є\n"\
                 "вираз власної вартости товару A. Paris vaut bien une messe.*\n"\
                 "\n"\
                 "* Париж таки вартий служби божої. Ред."
        result = "valer, valoir, висловлює, що порівняння товару В з товаром А є\n"\
                 "вираз власної вартости товару A. Paris vaut bien une messe.\\footnote*{
                  \nПариж таки вартий служби божої. Ред.
                 }\n"\
                 "\n"
        expect(TexProcessing.footnotes(source)).to eq result
      end
    end

    # context 'with a simple text' do
    #   it 'insert footnotes in proper places' do
    #     source = read_file('footnotes.simple.txt')
    #     result = read_file('footnotes.simple.result.txt')

    #     expect(TexProcessing.footnotes(source)).to eq result
    #   end
    # end
    # context 'with a complex text' do
    #   it 'insert footnotes in proper places' do
    #     source = read_file('footnotes.complex.txt')
    #     result = read_file('footnotes.complex.result.txt')

    #     expect(TexProcessing.footnotes(source)).to eq result
    #   end
    # end
  end

  describe '.insert_footnote' do
    context 'with number footnote' do
      it 'insert single footnote in proper place' do
        source = "Here is text line nil\n"\
                 "Here is text 24 line one\n"\
                 "Here is text line two"
        footnote = "24 Here is footnote line 1\n"\
                 "Here is footnote line 2"

        result = "Here is text line nil\n"\
                 "Here is text \\footnote{\n"\
                 "Here is footnote line 1\n"\
                 "Here is footnote line 2}\n"\
                 "line one\n"\
                 "Here is text line two"

        expect(TexProcessing.insert_footnote(source, footnote)).to eq result
      end
    end
    context 'with asteriks footnote' do
      it 'insert single footnote in proper place' do
        source = "Here is text line nil\n"\
                 "Here is text * line one\n"\
                 "Here is text line two"
        footnote = "* Here is footnote line 1\n"\
                 "Here is footnote line 2"

        result = "Here is text line nil\n"\
                 "Here is text \\footnote*{\n"\
                 "Here is footnote line 1\n"\
                 "Here is footnote line 2}\n"\
                 "line one\n"\
                 "Here is text line two"
        expect(TexProcessing.insert_footnote(source, footnote)).to eq result
      end
    end
    # context 'if mistaken footnote was find' do
    #   it 'doesnt change text' do
    #     source = "Here is text line nil\n"\
    #              "20 Here is text line, but look like footnote\n"\
    #              "Here is text line two"
    #     footnote = "20 Here is text line, but look like footnote\n"\
    #                "Here is text line two"
    #     expect(TexProcessing.insert_footnote(source, footnote)).to eq source
    #   end
    # end
  end

  describe '.footnote_id' do
    context 'with two digit number' do
      it 'return number ' do
        footnote = "24 Here is footnote line 1\n"\
                   "Here is footnote line 2"
        expect(TexProcessing.footnote_id(footnote)).to eq "24"
      end
    end
  end

  describe '.text_only' do
    context 'with a sample text' do
      context 'with number footnote' do
        it 'remove_footnotes' do
          source = "Here is text line one\n"\
                   "Here is text line two\n"\
                   "Here is text line three\n"\
                   "\n"\
                   "24 Here is footnote line one\n"\
                   "Here is footnote line two\n"\
                   "* Here is new footnote"
          result = "Here is text line one\n"\
                   "Here is text line two\n"\
                   "Here is text line three\n"
          expect(TexProcessing.text_only(source)).to eq result
        end
      end
      context 'with asteriks footnote' do
        it 'remove_footnotes' do
          source = "Here is text line one\n"\
                   "Here is text line two\n"\
                   "Here is text line three\n"\
                   "\n"\
                   "* Here is new footnote"
          result = "Here is text line one\n"\
                   "Here is text line two\n"\
                   "Here is text line three\n"
          expect(TexProcessing.text_only(source)).to eq result
        end
      end
    end
    context 'with a complex text' do
      it 'remove footnotes' do
        source = read_file('footnotes.complex.txt')
        result = read_file('footnotes.complex.no_footnote.txt')

        expect(TexProcessing.text_only(source)).to eq result
      end
    end
  end

  describe '.footnotes_only' do
    context 'with a sample text' do
      context 'with number footnote' do
        it 'remove_footnotes' do
          source = "Here is text line one\n"\
                   "Here is text line two\n"\
                   "Here is text line three\n"\
                   "\n"\
                   "24 Here is footnote line one\n"\
                   "Here is footnote line two\n"\
                   "* Here is new footnote"
          result = "\n\n24 Here is footnote line one\n"\
                   "Here is footnote line two\n"\
                   "* Here is new footnote"
          expect(TexProcessing.footnotes_only(source)).to eq result
        end
      end
      context 'with asteriks footnote' do
        it 'remove_footnotes' do
          source = "Here is text line one\n"\
                   "Here is text line two\n"\
                   "Here is text line three\n"\
                   "\n"\
                   "* Here is new footnote"
          result = "\n\n* Here is new footnote"
          expect(TexProcessing.footnotes_only(source)).to eq result
        end
      end
    end
  end

  describe '.footnotes_array' do
    context 'with a sample text' do
      it 'return array of footnote' do
        source = "Here is text line 0\n"\
                 "Here is text line 1\n"\
                 "Here is text line 2\n"\
                 "\n"\
                 "24 Here is footnote line 1\n"\
                 "Here is footnote line 2\n"\
                 "* Here is new footnote"
        first_footnote = "24 Here is footnote line 1\n"\
                         "Here is footnote line 2"
        second_footnote = "* Here is new footnote"

        expect(TexProcessing.footnotes_array(source)).to eq [first_footnote, second_footnote]
      end
    end
    context 'with a simple text' do
      it 'return array of footnote' do
        source = read_file('footnotes.simple.txt')

        first_footnote = "18 У деякому відношенні з людиною справа стоїть так, як із товаром.\n"\
                         "Через те, що вона родиться на світ ані з дзеркалом, ані як фіхтівський\n"\
                         "філософ: «Я є я», то людина спершу видивляється в іншу людину, як у\n"\
                         "дзеркало. Лише через відношення до людини Павла як до подібного до\n"\
                         "себе, людина Петро відноситься й до себе самої як до людини. Але тим\n"\
                         "самим і Павло з шкурою й волоссям, у його Павловій тілесності, стає для\n"\
                         "нього за форму виявлення роду «людина».\n"

        second_footnote = "* Париж таки вартий служби божої. Ред."

        expect(TexProcessing.footnotes_array(source)).to eq [first_footnote, second_footnote]
      end
    end
  end

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
                   "\n"\
                   "24 Here is footnote line 1\n"\
                   "Here is footnote line 2\n"\
                   "* Here is new footnote"
        expect(TexProcessing.all_footnote_line_numbers(source)).to eq [2,4]
      end
    end
    context 'with a simple text' do
      it 'return footnote`s line number array' do
        source = read_file('footnotes.simple.txt')

        expect(TexProcessing.all_footnote_line_numbers(source)).to eq [2,10]
      end
    end
    context 'with a coomplex text' do
      it 'return footnote`s and mistakeline number array' do
        # if line starts with number it recognised as footnote
        source = read_file('footnotes.complex.txt')

        expect(TexProcessing.all_footnote_line_numbers(source)).to eq [2, 26, 27]
      end
    end
  end
end
