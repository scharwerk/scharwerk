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
                 "Here is text\\footnote{\n"\
                 "Here is footnote line 1\n"\
                 "Here is footnote line 2\n}"\
                 " line one\n"\
                 "Here is text line two"
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

        result = "Here is text\\footnote*{\nHere is second footnote\n} line nil\n"\
                 "Here is text\\footnote{\n"\
                 "Here is footnote line 1\n"\
                 "Here is footnote line 2\n}"\
                 " line one\n"\
                 "Here is text line two"
        expect(TexProcessing.footnotes(source)).to eq result
      end
    end

    context 'with a sample text and letters footnotes' do
      it 'insert footnote in proper places' do
        source = "Here is text* line nil\n"\
                 "Here is text 24a line one\n"\
                 "Here is text line two\n"\
                 "\n"\
                 "24a Here is footnote line 1\n"\
                 "Here is footnote line 2\n"\
                 "\n"\
                 "* Here is second footnote"

        result = "Here is text\\footnote*{\nHere is second footnote\n} line nil\n"\
                 "Here is text\\footnoteA{\n"\
                 "Here is footnote line 1\n"\
                 "Here is footnote line 2\n}"\
                 " line one\n"\
                 "Here is text line two"
        expect(TexProcessing.footnotes(source, bracket=false, letter=true)).to eq result
      end
    end

    context 'with a sample text and bracket' do
      it 'insert footnote in proper places' do
        source = "Here is text* line nil\n"\
                 "Here is text 24) line one\n"\
                 "Here is text line two\n"\
                 "\n"\
                 "24) Here is footnote line 1\n"\
                 "Here is footnote line 2\n"\
                 "\n"\
                 "* ) Here is second footnote"

        result = "Here is text\\footnote*{\nHere is second footnote\n} line nil\n"\
                 "Here is text\\footnote{\n"\
                 "Here is footnote line 1\n"\
                 "Here is footnote line 2\n}"\
                 " line one\n"\
                 "Here is text line two"
        expect(TexProcessing.footnotes(source, bracket=true)).to eq result
      end
    end
    context 'with a footnote in the end text' do
      it 'insert footnote in proper places' do
        source = "Text 22\n\n22 footnote"

        result = "Text\\footnote{\nfootnote\n}"

        expect(TexProcessing.footnotes(source)).to eq result
      end
    end
    context 'with a num note footnote in the end text' do
      it 'insert footnote in proper places' do
        source = "one 22 two 22a three\n\n22 footnote\n\n22a footnotea"
        result = "one\\footnote{\nfootnote\n} two\\footnoteA{\nfootnotea\n} three"

        expect(TexProcessing.footnotes(source, false, true)).to eq result
      end
    end
  end

  describe '.footnote_id' do
    context 'with two digit number' do
      it 'return number ' do
        footnote = "24 Here is footnote line 1\n"\
                   "Here is footnote line 2"
        expect(TexProcessing.footnote_id(footnote)).to eq [
          "24", "Here is footnote line 1\nHere is footnote line 2"
        ]
      end
    end
    context 'with bracket' do
      it 'return number ' do
        footnote = "24 ) Here is footnote line 1\n"\
                   "Here is footnote line 2"
        expect(TexProcessing.footnote_id(footnote, true)).to eq [
          "24", "Here is footnote line 1\nHere is footnote line 2"
        ]
      end
    end
    context 'with letter' do
      it 'return number ' do
        footnote = "24г Here is footnote line 1\n"\
                   "Here is footnote line 2"
        expect(TexProcessing.footnote_id(footnote, false, true)).to eq [
          "24г", "Here is footnote line 1\nHere is footnote line 2"
        ]
      end
    end
  end

  it 'makes fracs' do
      source = 'sample 23/ 24 num 3 1/2 none /12'
      result = 'sample \sfrac{23}{24} num 3\sfrac{1}{2} none /12'

      expect(TexProcessing.fraction(source)).to eq result
  end

  it 'fixes dots' do
      source = 'table ....... 1 not table.... \n not table 2...'
      result = 'table \dotfill 1 not table\dots{} \n not table 2\dots{}'

      expect(TexProcessing.dots(source)).to eq result
  end

  it 'fixes dash in ranges' do
      source = '1*—2 II—X and — mdash'
      result = '1*--2 II--X and — mdash'

      expect(TexProcessing.ndash(source)).to eq result
  end

  it 'escapes percent and removes space' do
      source = " 4 \% 5\%"
      result = " 4\\% 5\\%"

      expect(TexProcessing.percent(source)).to eq result
  end

  skip it 'wraps book 1 math' do
      source = 'Товар Т\' але Т — Г. та Т — Г — Т\' '
      result = 'Товар $Т\'$ але $Т — Г$. та $Т — Г — Т\'$ '

      expect(TexProcessing.math_1(source)).to eq result
  end

  it 'wraps z p ' do
      source = 'Т < Р Зп$'
      result = 'Т \splitfrac{Р}{Зп}$'

      expect(TexProcessing.r_zp(source)).to eq result
  end

  it 'wraps book 2 math' do
      source = 'Princ. 1859 в II (v + m) мануфактурі 100 = v + m (де m = зискові капіталіста)'
      result = 'Princ. 1859 в II ($v + m$) мануфактурі $100 = v + m$ (де m = зискові капіталіста)'


      expect(TexProcessing.math_2(source)).to eq result
  end

  it 'gsubs text' do
      source = "0 text 1\nother 2"
      result = "(0) text (1)\nother (2)"
      t = TexProcessing.gsub(source, '\d') {|m| '(' + m[0] + ')'}
      expect(t).to eq result
  end

  it 'pounds text' do
      source = "3 фунти стерлінґів сто фунти стерлінґів"
      result = "3\\pound{ фунти стерлінґів} сто фунти стерлінґів"
      t = TexProcessing.pounds(source)
      expect(t).to eq result
  end

  it 'shoprt names ~' do
      source = "Mr. J. H. Otway Дж. Елліс"
      result = "Mr.~J.~H.~Otway Дж.~Елліс"
      t = TexProcessing.short_names(source)
      expect(t).to eq result
  end

  it 'signs' do
      source = "1 + 2 = 3"
      result = "1 \\dplus{} 2 \\deq{} 3"
      t = TexProcessing.signs(source)
      expect(t).to eq result
  end

  it 'shil pence text' do
      source = "1 шилінґ 5 пенсів. 1\\sfrac{1}{2} шилінґи "
      result = "1\\shil{ шилінґ} 5\\pens{ пенсів.} 1\\sfrac{1}{2}\\shil{ шилінґи} "
      t = TexProcessing.shilling(source)
      expect(t).to eq result
  end

  it 'abbrs text' do
      source = "в 1823 р. ввесь Протягом 1855, 1856 і 1857 рр. "
      result = "в 1823~\\abbr{р.} ввесь Протягом 1855, 1856 і 1857~\\abbr{рр.} "
      t = TexProcessing.abbrs(source)
      expect(t).to eq result
      
      source = "унції й т. ін., грошей і т. д. Addio!.. 7 "
      result = "унції й~\\abbr{т. ін.}, грошей і~\\abbr{т. д.} Addio\\elli{!..} 7 "
      t = TexProcessing.abbrs(source)
      expect(t).to eq result  
  end

  it 'nums wrap text' do
      source = "3.123 2.000.000 1895"
      result = "\\num{3.123} \\num{2.000.000} 1895"
      t = TexProcessing.numbers(source)
      expect(t).to eq result
  end

  it 'nums split_brackets' do
      source = "\\fisrt{texx {inside}} rest"
      t = TexProcessing.split_brackets(source)
      expect(t[0]).to eq "\\fisrt{texx {inside}}"
      expect(t[1]).to eq " rest"
  end

  it 'move_notes' do
      source = "text, \\footnote{\\emph{К. Marx} test} rest"
      result = "text\\footnote{\\emph{К. Marx} test}, rest"
      t = TexProcessing.move_notes(source)
      expect(t).to eq result
  end

  it 'fixes parcont' do
      source = "\\index{i}{0006}\nТому величина"
      result = "\\index{i}{0006}\n\nТому величина"
      t = TexProcessing.parcont_fix(source)
      expect(t).to eq result
  end

  it 'fixes parcont' do
      source = "\\index{i}{0006}\n\nТому величина"
      result = "\n\\index{i}{0006}\nТому величина"
      t = TexProcessing.index_n_fix(source)
      expect(t).to eq result
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

        first_footnote = "18 У деякому відношенні з людиною справа стоїть так, як із товаром.\n"\
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

end
