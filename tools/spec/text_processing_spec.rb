# Replase test data from spec
require 'spec_helper'

describe TextProcessing do
  describe '#change_quotes' do
    it 'return text with «...» instead „...“' do
      text1 =  ' с., р. 40). „Навпаки,
єдино правильний метод той, щоб на доходи кожного року покладати
зневартнення, неминуче зв’язане з тим, щоб заслужити ці доходи, все
одно, чи витрачено дану суму, чи ні“ (Captain '
      text2 =  ' с., р. 40). «Навпаки,
єдино правильний метод той, щоб на доходи кожного року покладати
зневартнення, неминуче зв’язане з тим, щоб заслужити ці доходи, все
одно, чи витрачено дану суму, чи ні» (Captain '
      text_proc = TextProcessing.new(text1)
      expect(text_proc.change_quotes).to eq text2
    end
  end

  describe '#remove_trailing_whitespace' do
    it 'remove space in an end of a line' do
      # Don`t touch trailing whitespace in the spec
      text1 =  'Навпаки,
єдино правильний метод той, щоб на доходи кожного року покладати 
зневартнення, неминуче зв’язане з тим, щоб заслужити ці доходи, все
одно, чи витрачено дану суму, чи ні“ (Captain'
      text2 =  'Навпаки,
єдино правильний метод той, щоб на доходи кожного року покладати
зневартнення, неминуче зв’язане з тим, щоб заслужити ці доходи, все
одно, чи витрачено дану суму, чи ні“ (Captain'
      text_proc = TextProcessing.new(text1)
      expect(text_proc.remove_trailing_whitespace).to eq text2
    end
    it 'remove space in a begining of a line' do
      text1 =  'Навпаки,
 єдино правильний метод той, щоб на доходи кожного року покладати
зневартнення, неминуче зв’язане з тим, щоб заслужити ці доходи, все
одно, чи витрачено дану суму, чи ні“ (Captain'
      text2 =  'Навпаки,
єдино правильний метод той, щоб на доходи кожного року покладати
зневартнення, неминуче зв’язане з тим, щоб заслужити ці доходи, все
одно, чи витрачено дану суму, чи ні“ (Captain'
      text_proc = TextProcessing.new(text1)
      expect(text_proc.remove_trailing_whitespace).to eq text2
    end
    it 'remove multiple spaces' do
      text1 =  'Навпаки,
єдино  правильний метод той, щоб на доходи кожного року покладати
зневартнення, неминуче зв’язане з тим, щоб заслужити ці доходи, все
одно, чи витрачено дану суму, чи ні“ (Captain'
      text2 =  'Навпаки,
єдино правильний метод той, щоб на доходи кожного року покладати
зневартнення, неминуче зв’язане з тим, щоб заслужити ці доходи, все
одно, чи витрачено дану суму, чи ні“ (Captain'
      text_proc = TextProcessing.new(text1)
      expect(text_proc.remove_trailing_whitespace).to eq text2
    end
  end

  describe '#capitalize_line' do
    it 'replace all laters to capitalize except first' do
      line1 = 'КРУГОБІГ ТОВАРОВОГО КАПІТАЛУ'
      line2 = 'Кругобіг товарового капіталу'
      text_proc = TextProcessing.new(line1)
      expect(text_proc.capitalize_line(line1)).to eq line2
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
        text1 = "капітал
фігурує лише як товар; але коли мова йде про складові частини варто-
сти, то"
        text2 = "капітал
фігурує лише як товар; але коли мова йде про складові частини вартости,
то"
        # now it add additional whitespace in the begining of line
        text_proc = TextProcessing.new(text1)
        expect(text_proc.remove_line_breaks).to eq text2
      end
    end
  end
  describe '#capitalize_heading' do
    context 'a text with heading' do
      it 'return text with capitalize heading' do
        text1 = 'капіталу є та форма, що в ній класична
економія розглядає процес кругобігу промислового капіталу.

РОЗДІЛ ТРЕТІЙ

КРУГОБІГ ТОВАРОВОГО КАПІТАЛУ

Загальна формула для кругобігу товарового капіталу така:'
        text2 = 'капіталу є та форма, що в ній класична
економія розглядає процес кругобігу промислового капіталу.

Розділ третій

Кругобіг товарового капіталу

Загальна формула для кругобігу товарового капіталу така:'
        text_proc = TextProcessing.new(text1)
        expect(text_proc.capitalize_heading(text1)).to eq text2
      end
    end
  end

  describe '#add_empty_line' do
    context 'for text with no empty line at the end' do
      it 'add`s an empty line at the end of a file' do
        text1 = 'на найманих робітників'

        text2 = 'на найманих робітників
'
        text_proc = TextProcessing.new(text1)
        expect(text_proc.add_empty_line).to eq text2
      end
      context 'with a real text' do
        it 'add`s an empty line at the end of a file' do
          text1 = "на найманих робітників.

Подруге. Товари, що входять у процес циркуляції промислового
капіталу (сюди належать і доконечні засоби існування, що на них пере-"

          text2 = "на найманих робітників.

Подруге. Товари, що входять у процес циркуляції промислового
капіталу (сюди належать і доконечні засоби існування, що на них пере-
"
          text_proc = TextProcessing.new(text1)
          expect(text_proc.add_empty_line).to eq text2
        end
      end
    end
    context 'for text with no empty line at the end' do
      it 'do not add`s an empty line at the end of a file' do
        text1 = 'на найманих робітників
'
        text_proc = TextProcessing.new(text1)
        expect(text_proc.add_empty_line).to eq text1
      end
    end
  end

  describe '#replace_double_chars' do
    # TODO: it could be as well X
    it 'Replace double chars on line break (—, =, +, -)' do
      text1 = '(таблиці XVI і XVII), і сума ренти є знову 6X20=10X12 =
= 120 шил.'
      text2 = '(таблиці XVI і XVII), і сума ренти є знову 6X20=10X12 =
120 шил.'
      text_proc = TextProcessing.new(text1)
      expect(text_proc.replace_double_chars). to eq text2
    end
  end
end
