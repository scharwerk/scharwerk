# This is a class for automatic text upgrade
class TexProcessing

  def self.footnotes(text)
    text
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
