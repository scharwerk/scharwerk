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

  describe '.insert_footnote' do
    context 'if footnote match' do
      it 'insert single footnote in proper place' do
        source = "Here is text line nil\n"\
                 "Here is text 24 line one\n"\
                 "Here is text line two"
        footnote = "24 Here is footnote line 1\n"\
                 "Here is footnote line 2"

        result = "Here is text line nil\n"\
                 "Here is text \footnote{\n"\
                 "Here is footnote line 1\n"\
                 "Here is footnote line 2}\n"\
                 "line one\n"\
                 "Here is text line two"

        expect(TexProcessing.insert_footnote(source, footnote)).to eq result
      end
    end
    context 'if mistaken footnote was find' do
      it 'doesnt change text' do
        source = "Here is text line nil\n"\
                 "20 Here is text line, but look like footnote\n"\
                 "Here is text line two"
        footnote = "20 Here is text line, but look like footnote\n"\
                   "Here is text line two"
        expect(TexProcessing.insert_footnote(source, footnote)).to eq source
      end
    end
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



  describe '.footnotes_array' do
    context 'with a sample text' do
      it 'return array of footnote' do
        source = "Here is text line 0\n"\
                 "Here is text line 1\n"\
                 "Here is text line 2\n"\
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

        first_footnote = "18    У деякому відношенні з людиною справа стоїть так, як із товаром.\n"\
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
#     context 'with a complex text' do
#       it 'return array of footnote' do
#         source = read_file('footnotes.complex.txt')

#         mistake_footnote = "20 метрів полотна = 20 метрам полотна — тавтологію, де не виражено\n"\
# "ні вартости, ані величини вартости. Щоб виразити відносну\n"\
# "вартість загального еквіваленту, ми скорше мусимо обернути\n"\
# "форму С. Він не має спільної з іншими товарами відносної\n"\
# "форми вартости, але його вартість відносно виражається у без-\n"

#         first_footnote = "24 В дійсності на перший погляд з форми загальної безпосередньої\n"\
# "вимінности ніяк не пізнати, що вона є суперечна товарова форма, так\n"\
# "само невіддільна від протилежної форми, що в ній неможлива безпосередня\n"\
# "вимінність, як позитивний полюс магнету від його негативного полюса.\n"\
# "Тим то уявити собі, що на всі товари можна одночасно наложити печать\n"\
# "безпосередньої вимінности можна з таким самим успіхом, як можна\n"\
# "уявити собі, що всіх католиків можна одночасно поробити папами. Для\n"\
# "дрібного буржуа, який у товаровій продукції бачить nec plus ultra *\n"\
# "людської волі й індивідуальної незалежности, було б, натурально, дуже\n"\
# "бажано позбавитись невигід, зв’язаних з цією формою, особливо ж тієї, що\n"\
# "товари не можуть вимінюватись безпосередньо. Розмальовування цієї філістерської\n"\
# "утопії становить прудонівський соціялізм, який, як я це показав\n"\
# "в іншому місці, не має в собі навіть нічого ориґінального і який далеко\n"\
# "раніш значно краще розвинули були Gray, Bray і ін. Та це не заважає\n"\
# "отакій мудрості ще й нині, як якійсь пошесті, ширитися в певних колах\n"\
# "під ім’ям «science».** Жодна школа не панькалась так із словом «science»,\n"\
# "як прудонівська, бо\n"\
# "«Wo Begriffe fehlen,\n"\
# "da stellt zur rechten Zeit ein Wort sich ein»\n"\
# "(«Де бракує понять, там саме в пору з’являється слово»).\n"

#         second_footnote = "* — вершину. Ред"

#         third_footnote = "** — «наука». Ред."

#         expect(TexProcessing.footnotes_array(source)).to eq [mistake_footnote, first_footnote, second_footnote, third_footnote]
#       end
#     end
  end
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
