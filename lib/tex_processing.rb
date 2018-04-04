# This is a class for automatic text upgrade
class TexProcessing

  def self.footnotes(text)
    text
  end

  # def self.collect_footnotes(text)
  #   footnote_index = TexProcessing.first_footnote_index(text)
  #   ar_tex = text.split(/\n/)
  #   ar_tex.slice!(0..(footnote_index-1))
  #   ar_tex.join("\n")
  # end

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

  # def self.grab_footnote_paragraph(text)
  #   #find first footnote index
  #   #iterate to next footnote, push lines to ar
  #   #join array into footnote

  #   # it collect footnote paragraph if any exist, and delete it
  #   ar_text = text.split(/\n/)
  #   ar_paragraph = []
  #   ar_text.each do |line|
  #     if TexProcessing.footnote_line?(line)

  #       ar_paragraph << line
  #       break
  #     end
  #   end
  #   ar_paragraph.join("\n")
  # end

  def self.grab_footnote_paragraph(text)
    line_number = TexProcessing.first_footnote_index(text)
    ar_text = text.split(/\n/)
    ar_footnonte_paragraph = [ar_text[line_number]]
    ar_text[(line_number+1)..-1].each do |line|
      ar_footnonte_paragraph << line if !TexProcessing.footnote_line?(line)
    end
    ar_footnonte_paragraph.join("\n")
  end

  # def self.footnote?(paragraph)
  #   return false if paragraph.match(/^\d\./) || paragraph.match(/^\d\d\./)
  #   return true if paragraph.match(/^\d/) || paragraph.match(/^\*/)
  #   false
  # end

  # def self.footnotes_array(text)
  #   result = []
  #   text.split(/\n\n/).each do |paragraph|
  #     result << paragraph if footnote?(paragraph)
  #   end
  #   result
  # end
end
