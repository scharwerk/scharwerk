# This is a class for joining files
class Joiner
  def self.join(path, config, index)
    parts = config.split("\n\n")

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
end
