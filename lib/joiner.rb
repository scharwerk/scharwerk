# This is a class for joining files
class Joiner
  def self.read_file(path, page, index)
    name = page.delete('*-')

    text = File.read(File.join(path, name))
    text = text.gsub(/\s+\Z/, '').gsub(/\A\s+/, '')

    flags = page.slice(name.length..-1)
    index = name.split('.')[0]
    return text, flags, index
  end

  def self.join(path, config, index)
    config.split("\n\n").each do |part|
      text = ''
      name = ''
      complex = false
      part.split("\n").each do |page|
        t, f, i = self.read_file(path, page, index)
        text += t
        name += '_' + i
        complex = (complex or (f.index('*') != nil))
      end
      filename =name + (complex ? 'c' : '') + '.tex'
      File.write(File.join(path, filename), text)
    end
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
