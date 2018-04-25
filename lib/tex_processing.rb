# This is a class for automatic text upgrade
class TexProcessing

  def self.footnotes(text, bracket=false)
    text, *notes = TexProcessing.footnotes_array(text)
    notes.each do |footnote|
      text = TexProcessing.insert_footnote(text, footnote, bracket)
    end
    text
  end

  def self.footnotes_bracket(text)
    self.footnotes(text, bracket=true)
  end

  def self.wrap100(text)
    text.gsub(/(.{1,100})(\s|\Z)/, "\\1\n")
  end

  def self.percent(text)
    text = text.gsub(/\s*\%/, '\\%')
  end

  def self.fraction(text)
    text = text.gsub(%r{(\d+)\s*/\s*(\d+)}, '\sfrac{\\1}{\\2}')
    text.gsub(/(\d)\s*\\sfrac/, '\\1\sfrac')
  end

  def self.dots(text)
    text = text.gsub(/…/, '...')
    text = text.gsub(/\.{5,}/, '\dotfil')
    text.gsub(/\.{3,}/, '\dots{}')
  end

  def self.ndash(text)
    text = text.gsub(/([\d\*])—([\d\*])/, '\\1--\\2')
    text.gsub(/([IVX\*])—([\*IVX\*])/, '\\1--\\2')
  end

  def self.footnote_type(id)
    return '\footnote*' if id.include?('*')
    '\footnote'
  end

  def self.insert_footnote(text, footnote, bracket=false)
    f_id, f_text = footnote_id(footnote, bracket)
    br = bracket ? '\s*?\)?' : ''
    placehold = Regexp.new ('([^\d\*])\s*' + Regexp.quote(f_id) + br + '([^\d\*])')
    return text + "\n\n" + footnote unless text.scan(placehold).count == 1

    text.gsub(placehold) do |mark|
      "#{$1}" + footnote_type(f_id) + "{\n#{f_text}\n}#{$2}"
    end
  end

  def self.footnote_id(footnote, bracket=false)
    id = footnote[/[\d\*]+/]
    text = footnote.gsub(/\A\s*[\d\*]+\s*/, '').strip
    text = text.gsub(/\A\s*\)\s*/, '') if bracket
    return id, text
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
    text.split(/(?=\n\n[\d\*]+)\s*/)
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
end
