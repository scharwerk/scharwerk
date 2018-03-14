# This is a class for automatic text upgrade
class TexProcessing
  
  def self.footnotes(text)
    text
  end

  def self.fraction(text)
    text.gsub(/(\d+)\s*\/\s*(\d+)/, '\sfrac{\\1}{\\2}')
  end
end
