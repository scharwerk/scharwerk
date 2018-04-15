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
    context 'with a sample text' do
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
                 " line one\n"\
                 "Here is text line two"
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
                 " line one\n"\
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
                 " line one\n"\
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

  describe '.footnotes_array' do
    context 'with a sample text' do
      it 'return array of footnote' do
        text = "Here is text line 0\n"\
                 "Here is text line 1\n"\
                 "Here is text line 2"

        source = text + "\n\n"\
                 "24 Here is footnote line 1\n"\
                 "Here is footnote line 2\n\n"\
                 "* Here is new footnote"
        first_footnote = "24 Here is footnote line 1\n"\
                         "Here is footnote line 2"
        second_footnote = "* Here is new footnote"

        expect(TexProcessing.footnotes_array(source)).to eq [text, first_footnote,  second_footnote]
      end
    end
    context 'with a simple text' do
      it 'return array of footnote' do
        source = read_file('footnotes.simple.txt')

        first_footnote = "18    У деякому відношенні з людиною справа стоїть так, як із товаром.\n"\
                         "Через те, що вона родиться на світ ані з дзеркалом, ані як фіхтівський\n"\
                         "філософ: «Я є я», то людина спершу видивляється в іншу людину, як у\n"\
                         "дзеркало. Лише через відношення до людини Павла як до подібного до\n"\
                         "себе, людина Петро відноситься й до себе самої як до людини. Але тим\n"\
                         "самим і Павло з шкурою й волоссям, у його Павловій тілесності, стає для\n"\
                         "нього за форму виявлення роду «людина»."

        second_footnote = "* Париж таки вартий служби божої. Ред.\n"

        expect(TexProcessing.footnotes_array(source)[1]).to eq first_footnote
        expect(TexProcessing.footnotes_array(source)[2]).to eq second_footnote
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
end
