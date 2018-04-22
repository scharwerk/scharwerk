# This looks awfull
class Joiner
  def self.read_file(path, page, index)
    name = page.delete('*-')

    text = File.read(File.join(path, name)).strip

    index = name.split('.')[0]
    is_break = page.index('-') != nil
    complex = page.index('*') != nil
    return text, index, is_break, complex
  end

  def self.prefix(index, i)
    "\n\\index{#{index}}{#{i}}\n"
  end

  def self.join(path, config, index)
    parts = config.split("\n\n")
    parts.each_with_index do |part, part_i|
      text = ''
      name = ''
      complex = false
      break_before = false
      part.split("\n").each_with_index do |page, p|
        t, i, b, c = self.read_file(path, page, index)
        break_before = b if p == 0
        text = join_text(text, prefix(index, i), t, b)
        name += '_' + i
        complex = complex or c
      end
      filename = name + (complex ? 'c' : '') + '.tex'
      next_page = parts.fetch(part_i + 1, '\n').lines.first
      break_after = next_page.index('-') != nil
      puts break_after

      text = text.strip
      text = "\\parcont{}\n" + text unless break_before
      text += "\n\\parbreak{}" unless break_after
      text += "\n"

      File.write(File.join(path, filename), text)
    end
  end

  def self.remove_end(text1, text2)
    text1 = text1.gsub(/-\z/) do
      word = '-'
      text2 = text2.gsub(/\A(\S+)\s/) do
        word = "#{$1}"
        ''
      end
      word
    end
    return text1, text2
  end

  def self.join_text(text1, pref, text2, is_break)
    text1, text2 = self.remove_end(text1, text2) unless is_break
    text1 += "\n" if is_break
    text1 + pref + text2  
  end
end
