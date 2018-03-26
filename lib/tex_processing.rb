# This is a class for automatic text upgrade
class TexProcessing

  def self.footnotes(text)
    text
  end

  def self.footnote?(paragraph)
    return false if paragraph.match(/^\d\./) || paragraph.match(/^\d\d\./)
    return true if paragraph.match(/^\d/) || paragraph.match(/^*/)
  end
end
