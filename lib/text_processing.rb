# This is a class for automatic text upgrade
class TextProcessing
  DOWNCASE_CAPITAL = { 'А' => 'а', 'Б' => 'б', 'В' => 'в', 'Г' => 'г',
                       'Ґ' => 'ґ', 'Д' => 'д', 'Е' => 'е', 'Є' => 'є',
                       'Ж' => 'ж', 'З' => 'з', 'И' => 'и', 'І' => 'і',
                       'Ї' => 'ї', 'Й' => 'й', 'К' => 'к', 'Л' => 'л',
                       'М' => 'м', 'Н' => 'н', 'О' => 'о', 'П' => 'п',
                       'Р' => 'р', 'С' => 'с', 'Т' => 'т', 'У' => 'у',
                       'Ф' => 'ф', 'Х' => 'х', 'Ц' => 'ц', 'Ч' => 'ч',
                       'Ш' => 'ш', 'Щ' => 'щ', 'Ь' => 'ь', 'Ю' => 'ю',
                       'Я' => 'я' }.freeze

  def initialize(text)
    @text = text
  end

  def change_quotes
    @text = @text.gsub(/[„“]/, '„' => '«', '“' => '»')
  end

  def remove_bom
    @text.delete(/\uFEFF/)
  end

  def replace_tabs_with_spaces
    @text.gsub(/\t/, '    ')
  end

  def remove_trailing_whitespace
    @text.gsub(/[^\S\n]+?$/, '')
  end

  def remove_multiple_nl
    @text.gsub(/\n{2,}/, "\n\n")
  end

  def capitalize_line(line)
    new_line = []
    line.split(' ').each do |word|
      new_line << downcase_word(word)
    end
    upcase_first_letter(new_line.join(' ')) << "\n"
  end

  def upcase_first_letter(line)
    line[0] = DOWNCASE_CAPITAL.key(line[0]) if DOWNCASE_CAPITAL.value?(line[0])
    line
  end

  def downcase_word(word)
    new_word = ''
    word.each_char do |letter|
      new_word << if DOWNCASE_CAPITAL.include?(letter)
                    DOWNCASE_CAPITAL[letter]
                  else
                    letter
                  end
    end
    new_word
  end

  def uppercase_line?(line)
    return true if line.match(/\p{Upper}/) && !line.match(%r{[\p{Lower}—/\\]})
    false
  end

  def remove_line_breaks
    @text.gsub(/-\n(\S+)\s+/, "\\1\n")
    # In plain English, we looking for a pattern (/(-\n)(\S+)\s/),
    # that represent, hyphen then end of a line, then any charcter except
    # whitespace, then whitespace and replace with second group of pattern
    # \\1 means referance to (\S+), then end of a line \n
  end

  def capitalize_heading
    # TODO: somehow remuve new_text variable
    new_text = ''
    @text.each_line do |line|
      new_text << if uppercase_line?(line)
                    capitalize_line(line)
                  else
                    line
                  end
    end
    @text = new_text
  end

  def add_empty_line
    # TODO: line schold be ended with \n or \n\n ?
    @text =~ /\S\z/ ? @text << "\n" : @text
    # \z match end of a string
    # \S match any symbol except whitespace and Line seperator
  end

  def replace_double_chars
    @text = @text.gsub(/([+×\-=—X])\n\1\s*/, "\\1\n")
  end

  def add_space_before(char)
    @text = @text.gsub(/(\S)[^\S\n]*#{Regexp.escape(char)}/, "\\1 #{char}")
  end

  def add_space_after(char)
    @text = @text.gsub(/#{Regexp.escape(char)}[^\S\n]*(\S)/, "#{char} \\1")
  end

  def add_space_around(char)
    add_space_before(char)
    add_space_after(char)
  end

  def remove_space_before(char)
    @text = @text.gsub(/(\S)[^\S\n]*#{Regexp.escape(char)}/, "\\1#{char}")
  end

  def remove_space_after(char)
    @text = @text.gsub(/#{Regexp.escape(char)}[^\S\n]*(\S)/, "#{char}\\1")
  end

  def fix_space_in_math
    '=+×'.each_char { |c| add_space_around(c) }
    @text
  end

  def fix_space_around
    ')]}“»;:'.each_char { |c| add_space_after(c) }
    '([{„«'.each_char { |c| add_space_before(c) }

    # add space after if next char is not dot
    @text = @text.gsub(/\?[^\S\n]*([^\s\.\*])/, "\? \\1")
    @text = @text.gsub(/\![^\S\n]*([^\s\.\*])/, "\! \\1")

    # add space after if next char is not number or dot
    @text = @text.gsub(/\.[^\S\n]*([^\s\d\.\*])/, "\. \\1")
    @text = @text.gsub(/\,[^\S\n]*([^\s\d\.\*])/, "\, \\1")

    ')]}“»;:,?!%'.each_char { |c| remove_space_before(c) }
    '([{„«'.each_char { |c| remove_space_after(c) }

    # remove space before dot, if previous char is not dor
    @text = @text.gsub(/([^\s\.])[^\S\n]*\./, '\\1.')
    @text
  end

  def fix_white_space
    @text = remove_bom
    @text = replace_tabs_with_spaces
    @text = remove_trailing_whitespace
    @text = add_empty_line
    @text = remove_multiple_nl
  end

  def add_spaces_around_dash
    add_space_around('—')
  end

  def delete_spaces_around_dash
    @text = @text.gsub(/([\d\*IVX]) — ([\d\*IVX])/, '\\1—\\2')
  end

  def fix_ndash
    remove_space_before('-')
    remove_space_after('-')
    @text = @text.gsub(/([\d\*IVX])-([\d\*IVX])/, '\\1—\\2')
  end

  def spaces_around_dashes
    add_spaces_around_dash
    delete_spaces_around_dash
    fix_ndash
  end
end
