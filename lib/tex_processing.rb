# This is a class for automatic text upgrade
class TexProcessing

  def self.footnotes(text)
    text
  end

  def self.collect_footnotes(text)
    ar_tex = text.split(/\n/)
    ar_tex.each do |line|
      if TexProcessing.footnote_line?(line)
        break
      else
        ar_tex.delete(line)
      end
    end
    ar_tex.join("\n")
  end

  def footnote_line?(line)
    # return true if line is footnote
    return false if line.match(/^\d\./) || line.match(/^\d\d\./)
    return true if line.match(/^\d/) || line.match(/^\*/)
    false
  end

  def self.footnote?(paragraph)
    return false if paragraph.match(/^\d\./) || paragraph.match(/^\d\d\./)
    return true if paragraph.match(/^\d/) || paragraph.match(/^\*/)
    false
  end

  def self.footnotes_array(text)
    result = []
    text.split(/\n\n/).each do |paragraph|
      result << paragraph if footnote?(paragraph)
    end
    result
  end
end
