# This is a class for automatic text upgrade
class TexProcessing
  
  def self.footnotes(text)
    text
  end

  def self.fraction(text)
    text.gsub(%r{(\d+)\s*/\s*(\d+)}, '\sfrac{\\1}{\\2}')
  end

  def self.dots(text)
    text = text.gsub(/\.{5,}/, '\dotfil')
    text.gsub(/\.{3,}/, '\dots')
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
end
