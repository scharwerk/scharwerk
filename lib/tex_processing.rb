# This is a class for automatic text upgrade
class TexProcessing

  def self.footnotes(text)
    ar_footnotes = TexProcessing.footnotes_array(text)
    text = TexProcessing.text_only(text)
    ar_footnotes.each do |footnote|
      text = TexProcessing.insert_footnote(text, footnote)
    end
    text
  end

  def self.fraction(text)
    text.gsub(%r{(\d+)\s*/\s*(\d+)}, '\sfrac{\\1}{\\2}')
  end

  def self.dots(text)
    text = text.gsub(/\.{5,}/, '\dotfil')
    text.gsub(/\.{3,}/, '\dots')
  end

  def self.ndash(text)
    text = text.gsub(/([\d\*])—([\d\*])/, '\\1--\\2')
    text.gsub(/([IVX\*])—([\*IVX\*])/, '\\1--\\2')
  end

  def self.remove_end(text1, text2)
    text1 = text1.gsub(/\s+\Z/, '')
    text1 = text1.gsub(/-\z/) do
      word = '-'
      text2 = text2.gsub(/\A\s*(\S+)\s/) do
        word = "#{$1}\n"
        ''
      end
      word
    end
    return text1, text2
  end

  def self.join_text(text1, pref, text2, is_break)
    text1, text2 = self.remove_end(text1, text2) unless is_break
    text1 + pref + text2  
  end

  def self.insert_footnote(text, footnote)
    f_id = TexProcessing.footnote_id(footnote)
    footnote.slice!("#{f_id} ")
    if !f_id.include?('*')
      return text.gsub("#{f_id} ", "\\footnote{\n#{footnote}}\n")
    elsif f_id.include?('*')
      return text.gsub("#{f_id} ", "\\footnote\*{\n#{footnote}}\n")
    end
  end

  def self.footnote_id(footnote)
    footnote.split(' ').first
  end

  def self.first_footnote_index(text)
    ar_text = text.split(/\n/)
    ar_text.each do |line|
      return ar_text.find_index(line) if TexProcessing.footnote_line?(line)
    end
  end

  def self.footnote_line?(line)
    # return true if line is footnote
    return false if line.match(/^\d\./) || line.match(/^\d\d\./)
    return true if line.match(/^\d/) || line.match(/^\*/)
    false
  end

  def self.grab_footnote_paragraph(text, line_number)
    ar_text = text.split(/\n/)
    ar_footnonte_paragraph = [ar_text[line_number]]
    ar_text[(line_number+1)..-1].each do |line|
      ar_footnonte_paragraph << line if !TexProcessing.footnote_line?(line)
    end
    ar_footnonte_paragraph.join("\n")
  end


  def self.footnotes_array(text)
    footnote_text = TexProcessing.footnotes_only(text)
    ar = []
    footnotes_line_numbers = TexProcessing.all_footnote_line_numbers(text)
    footnotes_line_numbers.each do |line_number|
      ar << TexProcessing.grab_footnote_paragraph(footnote_text, line_number)
    end
    ar
  end

  def self.all_footnote_line_numbers(text)
    footnote_text = TexProcessing.footnotes_only(text)
    ar_footnote_line_numbers = []
    ar_text = footnote_text.split(/\n/)
    ar_text.each do |line|
      ar_footnote_line_numbers << ar_text.find_index(line) if TexProcessing.footnote_line?(line)
    end
    ar_footnote_line_numbers
  end

  def self.text_only(text)
    m_point = /\n\n\d/ =~ text
    m_point ||= /\n\n\*/ =~ text
    return text[0..m_point] if m_point
    text
  end

  def self.footnotes_only(text)
    m_point = /\n\n\d/ =~ text
    m_point ||= /\n\n\*/ =~ text
    return text[m_point..-1] if m_point
    text
  end
end
