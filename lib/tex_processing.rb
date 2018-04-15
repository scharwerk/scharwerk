# This is a class for automatic text upgrade
class TexProcessing

  def self.footnotes(text)
    text
  end

  def self.insert_footnote(text, footnote)
    f_id = TexProcessing.footnote_id(footnote)
    footnote.slice!("#{f_id} ")
    text.gsub("#{f_id} ", "\footnote{\n#{footnote}}\n")
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
    ar = []
    footnotes_line_numbers = TexProcessing.all_footnote_line_numbers(text)
    footnotes_line_numbers.each do |line_number|
      ar << TexProcessing.grab_footnote_paragraph(text, line_number)
    end
    ar
  end

  def self.all_footnote_line_numbers(text)
    ar_footnote_line_numbers = []
    ar_text = text.split(/\n/)
    ar_text.each do |line|
      ar_footnote_line_numbers << ar_text.find_index(line) if TexProcessing.footnote_line?(line)
    end
    ar_footnote_line_numbers
  end

  def self.remove_footnotes(text)
    m_point = /\n\n\d/ =~ text
    text[0..m_point]
  end
end
