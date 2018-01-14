# Replase test data from spec
require 'spec_helper'

describe TextProcessing do
  describe '#change_quotes' do
    it 'return text with «...» instead „...“' do
      text1 =  ' с., р. 40). „Навпаки,'\
        'єдино правильний метод той, щоб на доходи кожного року покладати'\
        'зневартнення, неминуче зв’язане з тим, щоб заслужити ці доходи, все'\
        'одно, чи витрачено дану суму, чи ні“ (Captain '
      text2 =  ' с., р. 40). «Навпаки,'\
        'єдино правильний метод той, щоб на доходи кожного року покладати'\
        'зневартнення, неминуче зв’язане з тим, щоб заслужити ці доходи, все'\
        'одно, чи витрачено дану суму, чи ні» (Captain '
      text_proc = TextProcessing.new(text1)
      expect(text_proc.change_quotes).to eq text2
    end
  end

  describe '#remove_trailing_whitespace' do
    it 'remove space in an end of a line' do
      # Don`t touch trailing whitespace in the spec
      text1 =  'Навпаки,'\
        'єдино правильний метод той, щоб на доходи кожного року покладати'\
        'зневартнення, неминуче зв’язане з тим, щоб заслужити ці доходи, все'\
        'одно, чи витрачено дану суму, чи ні“ (Captain'
      text2 =  'Навпаки,'\
        'єдино правильний метод той, щоб на доходи кожного року покладати'\
        'зневартнення, неминуче зв’язане з тим, щоб заслужити ці доходи, все'\
        'одно, чи витрачено дану суму, чи ні“ (Captain'
      text_proc = TextProcessing.new(text1)
      expect(text_proc.remove_trailing_whitespace).to eq text2
    end
    it 'remove space in a begining of a line' do
      text1 =  'Навпаки,'\
        'єдино правильний метод той, щоб на доходи кожного року покладати'\
        'зневартнення, неминуче зв’язане з тим, щоб заслужити ці доходи, все'\
        'одно, чи витрачено дану суму, чи ні“ (Captain'
      text2 =  'Навпаки,'\
        'єдино правильний метод той, щоб на доходи кожного року покладати'\
        'зневартнення, неминуче зв’язане з тим, щоб заслужити ці доходи, все'\
        'одно, чи витрачено дану суму, чи ні“ (Captain'
      text_proc = TextProcessing.new(text1)
      expect(text_proc.remove_trailing_whitespace).to eq text2
    end
  end

  describe '#capitalize_line' do
    it 'replace all laters to capitalize except first' do
      line1 = "КРУГОБІГ ТОВАРОВОГО КАПІТАЛУ\n"
      line2 = "Кругобіг товарового капіталу\n"
      text_proc = TextProcessing.new(line1)
      expect(text_proc.capitalize_line(line1)).to eq line2
    end
  end

  describe '#upcase_first_letter' do
    context 'with first letter downcase' do
      it 'upcase first line of a string' do
        line1 = 'кругобіг товарового капіталу'
        line2 = 'Кругобіг товарового капіталу'
        text_proc = TextProcessing.new(line1)
        expect(text_proc.upcase_first_letter(line1)).to eq line2
      end
    end
    context 'with first letter upcase' do
      it 'return string without changes' do
        line1 = 'Кругобіг товарового капіталу'
        line2 = 'Кругобіг товарового капіталу'
        text_proc = TextProcessing.new(line1)
        expect(text_proc.upcase_first_letter(line1)).to eq line2
      end
    end
  end

  describe '#downcase_word' do
    context 'with all upcase letters' do
      it 'downcase every leter of a word' do
        word1 = 'КРУГОБІГ'
        word2 = 'кругобіг'
        text_proc = TextProcessing.new(word1)
        expect(text_proc.downcase_word(word1)).to eq word2
      end
    end

    context 'with all downcase letters' do
      it 'downcase every leter of a word' do
        word1 = 'кругобіг'
        word2 = 'кругобіг'
        text_proc = TextProcessing.new(word1)
        expect(text_proc.downcase_word(word1)).to eq word2
      end
    end

    context 'with first upcase' do
      it 'downcase first letter' do
        word1 = 'Кругобіг'
        word2 = 'кругобіг'
        text_proc = TextProcessing.new(word1)
        expect(text_proc.downcase_word(word1)).to eq word2
      end
    end
  end

  describe '#uppercase_line?' do
    # TODO: It could be as well 'ROSDIL TRIDCYAT shostiy'
    context 'a line with all uppercase laters' do
      it 'return true' do
        line = 'КРУГОБІГ ТОВАРОВОГО КАПІТАЛУ'
        text_proc = TextProcessing.new(line)
        expect(text_proc.uppercase_line?(line)).to be true
      end
    end
    context 'with emty line' do
      it 'return false' do
        line = "\n"
        text_proc = TextProcessing.new(line)
        expect(text_proc.uppercase_line?(line)).to be false
      end
      it 'return false' do
        line = ''
        text_proc = TextProcessing.new(line)
        expect(text_proc.uppercase_line?(line)).to be false
      end
    end

    context 'a ordinary line' do
      it 'return false' do
        line = "циркуляції є Г — Т... Т'—Г' — Г — Т — Г. При"
        text_proc = TextProcessing.new(line)
        expect(text_proc.uppercase_line?(line)).to be false
      end
    end
    context 'with a only formula on line' do
      it 'return false, the formula contains dashes' do
        line = 'Т— Г —Т'
        text_proc = TextProcessing.new(line)
        expect(text_proc.uppercase_line?(line)).to be false
      end
      it 'return false, the formula contains dots' do
        line = "Т...Т'"
        text_proc = TextProcessing.new(line)
        expect(text_proc.uppercase_line?(line)).to be false
      end
      it 'return false, the formula contains slash' do
        line = '/Р'
        text_proc = TextProcessing.new(line)
        expect(text_proc.uppercase_line?(line)).to be false
      end
      it 'return false, the formula contains backslash' do
        line = '\Р'
        text_proc = TextProcessing.new(line)
        expect(text_proc.uppercase_line?(line)).to be false
      end
    end
  end

  describe '#remove_line_breaks' do
    context 'with a multiply text' do
      it 'concatenate word with hyphen' do
        text1 = "капітал\n"\
          "фігурує лише як товар; мова йде про складові частини варто-\n"\
          'сти, то'
        text2 = "капітал\n"\
          "фігурує лише як товар; мова йде про складові частини вартости,\n"\
          'то'
        # now it add additional whitespace in the begining of line
        text_proc = TextProcessing.new(text1)
        expect(text_proc.remove_line_breaks).to eq text2
      end
    end
  end
  describe '#capitalize_heading' do
    context 'a text with heading' do
      it 'return text with capitalize heading' do
        text1 = "капіталу є та форма, що в ній класична\n"\
          "економія розглядає процес кругобігу промислового капіталу.\n"\
          "\n"\
          "РОЗДІЛ ТРЕТІЙ\n"\
          "\n"\
          "КРУГОБІГ ТОВАРОВОГО КАПІТАЛУ\n"\
          "\n"\
          "Загальна формула для кругобігу товарового капіталу така:\n"
        text2 = "капіталу є та форма, що в ній класична\n"\
          "економія розглядає процес кругобігу промислового капіталу.\n"\
          "\n"\
          "Розділ третій\n"\
          "\n"\
          "Кругобіг товарового капіталу\n"\
          "\n"\
          "Загальна формула для кругобігу товарового капіталу така:\n"
        text_proc = TextProcessing.new(text1)
        expect(text_proc.capitalize_heading).to eq text2
      end
    end
  end

  describe '#add_empty_line' do
    context 'for text with no empty line at the end' do
      it 'add`s an empty line at the end of a file' do
        text1 = 'на найманих робітників'

        text2 = "на найманих робітників\n"

        text_proc = TextProcessing.new(text1)
        expect(text_proc.add_empty_line).to eq text2
      end
      context 'with a real text' do
        it 'add`s an empty line at the end of a file' do
          text1 = "на найманих робітників.\n\n"\
            "Подруге. Товари, що входять у процес циркуляції промислового\n"\
            "капіталу (доконечні засоби існування, що на них пере-"

          text2 = "на найманих робітників.\n\n"\
            "Подруге. Товари, що входять у процес циркуляції промислового\n"\
            "капіталу (доконечні засоби існування, що на них пере-\n"

          text_proc = TextProcessing.new(text1)
          expect(text_proc.add_empty_line).to eq text2
        end
      end
    end
    context 'for text with no empty line at the end' do
      it 'do not add`s an empty line at the end of a file' do
        text1 = 'на найманих робітників'

        text2 = "на найманих робітників\n"

        text_proc = TextProcessing.new(text1)
        expect(text_proc.add_empty_line).to eq text2
      end
    end
  end

  describe '#replace_double_chars' do
    # TODO: it could be as well X
    it 'Replace double chars on line break (—, =, +, -)' do
      text1 = "(таблиці XVI і XVII), і сума ренти є знову 6X20=10X12 =\n"\
        '= 120 шил.'
      text2 = "(таблиці XVI і XVII), і сума ренти є знову 6X20=10X12 =\n"\
        '120 шил.'
      text_proc = TextProcessing.new(text1)
      expect(text_proc.replace_double_chars). to eq text2
    end
  end

  describe '#get_dash_dict' do
    it 'returns_dict' do
      text = "дефіс-перший слово -дефіс але\n не пере-\nнос"
      p = TextProcessing.new(text)
      expect(p.get_dash_dict).to eq text
      expect{ p.get_dash_dict }.to output("дефіс-перший\nслово-дефіс\n").to_stdout
    end
  end

  describe '#fix_ndash' do
    it 'works' do
      text = "слово -дефіс і 1 - 10"
      result = "слово-дефіс і 1—10"
      p = TextProcessing.new(text)
      expect(p.fix_ndash).to eq result
    end

    it 'works with new lines' do
      text = "слово -\nдефіс"
      result = "слово-\nдефіс"
      p = TextProcessing.new(text)
      expect(p.fix_ndash).to eq result
    end
  end

  describe '#add_spaces_around_dash' do
    context 'whith no spaces before and after dash' do
      it 'add spaces' do
        text1 = "циркуляції є Г — Т... Т'—Г' — Г — Т — Г. При"
        text2 = "циркуляції є Г — Т... Т' — Г' — Г — Т — Г. При"
        text_proc = TextProcessing.new(text1)
        expect(text_proc.add_spaces_around_dash). to eq text2
      end
    end
    
    context 'with one space before dash' do
      it 'add space after' do
        text1 = "циркуляції є Г — Т... Т' —Г' — Г — Т — Г. При"
        text2 = "циркуляції є Г — Т... Т' — Г' — Г — Т — Г. При"
        text_proc = TextProcessing.new(text1)
        expect(text_proc.add_spaces_around_dash). to eq text2
      end
    end
    
    context 'with spece after dash only ' do
      it 'add spece before' do
        text1 = "циркуляції є Г — Т... Т'— Г' — Г — Т — Г. При"
        text2 = "циркуляції є Г — Т... Т' — Г' — Г — Т — Г. При"
        text_proc = TextProcessing.new(text1)
        expect(text_proc.add_spaces_around_dash). to eq text2
      end
    end

    context 'works on line end' do
      it 'add spece before' do
        text1 = "циркуляції—\nі далі"
        text2 = "циркуляції —\nі далі"
        text_proc = TextProcessing.new(text1)
        expect(text_proc.add_spaces_around_dash). to eq text2
      end
    end
  end
  describe '#delete_spaces_around_dash' do
    context 'with numbers around' do
      it 'delete spaces' do
        text1 = 'становить 1 — 3 розвоїв'
        text2 = 'становить 1—3 розвоїв'
        text_proc = TextProcessing.new(text1)
        expect(text_proc.delete_spaces_around_dash). to eq text2
      end
    end
  end

  describe '#process_spaces_around_dashes' do
    it 'add spaces with letters and delete spaces with numbers' do
      text1 = "циркуляції є Г — Т... Т'— Г' — Г — Т — Г. При розвої 1 — 100500"
      text2 = "циркуляції є Г — Т... Т' — Г' — Г — Т — Г. При розвої 1—100500"
      text_proc = TextProcessing.new(text1)
      expect(text_proc.spaces_around_dashes). to eq text2
    end
  end
end
