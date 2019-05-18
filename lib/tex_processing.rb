# This is a class for automatic text upgrade
class TexProcessing
  def self.wrap100(text)
    text.gsub(/(.{1,100})(\s|\Z)/, "\\1\n")
  end

  def self.split_brackets(text)
    c = 1
    (text.index('{') + 1 .. text.length ).each do |i|
      c = c + 1 if text[i] == '{'
      c = c - 1 if text[i] == '}'
      return text[0..i], text[i + 1 .. -1] if c == 0
    end
  end

  def self.move_notes(text)
    count = text.scan(/footnote/).length
    count.times do 
      text = gsub(text, /([\.\,])\s*(\\footnote.*)/m) do |m|
        r = split_brackets(m[2])
        r[0] + m[1] + r[1]
      end
    end
    text
  end

  def self.short_names(text)
    # do it twice
    text = gsub(text, '([[:upper:]][[:lower:]]?\.)\s([[:upper:]])') do |m|
      '%s~%s' % [m[1], m[2]]
    end
    gsub(text, '([[:upper:]][[:lower:]]?\.)\s([[:upper:]])') do |m|
      '%s~%s' % [m[1], m[2]]
    end 
  end

  def self.signs(text)
    text = gsub(text, '(\s)\=') { |m| m[1] + '\deq{}' }
    text = gsub(text, '(\s)\+') { |m| m[1] + '\dplus{}' }
  end

  def self.gsub(text, r, preview = 20)
    r = Regexp.new r
    left, right = '', text
    while m = r.match(right) do
      left += right[0..m.begin(0) - 1] if m.begin(0) > 0
      center = yield(m)
      right = right[m.end(0)..-1]
      # print preview
      left_p = left[-preview..-1] || left
      puts('-' + (left_p + m[0] + right[0..preview]).gsub(/\n/, ' '))
      puts('+' + (left_p + center + right[0..preview]).gsub(/\n/, ' '))

      left += center
    end
    left + right
  end

  def self.pounds(text)
    gsub(text, '(\d)\s*(фунт[[:word:]]*\s+стер[[:word:]]*)') do |m|
      '%s\pound{ %s}' % [m[1], m[2]]
    end
  end

  def self.shilling(text)
    text = gsub(text, '(\d\}?)\s*(шилін[[:word:]]*\.?)') do |m|
      '%s\shil{ %s}' % [m[1], m[2]]
    end
    gsub(text, '(\d\}?)\s*(пенс[[:word:]]*\.?)') do |m|
      '%s\pens{ %s}' % [m[1], m[2]]
    end
  end

  def self.abbrs(text)
    text = gsub(text, '(\d)\s*(рр?\.)') { |m| '%s~\abbr{%s}' % [m[1], m[2]] }
    text = gsub(text, '\s*(т\.\s+д\.)') { |m| '~\abbr{%s}' % [m[1]] }
    text = gsub(text, '\s*(т\.\s+ін\.)') { |m| '~\abbr{%s}' % [m[1]] }
    text = gsub(text, '\!\.\.') { '\elli{!..}' }
  end

  def self.numbers(text)
    gsub(text, '[\d\.]*\d\.\d\d\d') do |m|
      '\num{%s}' % [m[0]]
    end
  end

  def self.percent(text)
    text = text.gsub(/\s*\%/, '\\%')
  end

  def self.red(text)
    text = text.gsub('Ред.', '\emph{Ред.}')
  end


  def self.fraction(text)
    text = text.gsub(%r{(\d+)\s*/\s*(\d+)}, '\sfrac{\\1}{\\2}')
    text.gsub(/(\d)\s*\\sfrac/, '\\1\sfrac')
  end

  def self.math_letter(text)
    # we don't use it beacuse 
    # i make more errors then help
    # 'xyzwBC'.each_char do |l| 
    #   r = Regexp.new '(\W)' + l + '(\W)'
    #   text = text.gsub(r, '\\1$' + l + '$\\2')
    # end
    text
  end

  def self.math_1(text)
    text.gsub(/(\s)([ТтГгПпР][ТтГгПпРЗ'Δ…\<\.\s\-\+\=—]*[ТтГгПпР'])([\s\W])/, '\\1$\\2$\\3')
  end
  
  def self.math_2(text)
    text.gsub(/([cvm\d][cvm\d\s\/\+\=]{2,}[cvm])/, '$\\1$') do 
    end
  end

  def self.r_zp(text)
    text = text.gsub(/\<?\s+[PР]\s+Зп/, '\splitfrac{Р}{Зп}')
    text.gsub(/\<?\s+Зп\s+[PР]/, '\splitfrac{Р}{Зп}')
  end

  def self.dots(text)
    text = text.gsub(/…/, '...')
    text = text.gsub(/\.{5,}/, '\dotfill')
    text.gsub(/\.{3,}/, '\dots{}')
  end

  def self.ndash(text)
    text = text.gsub(/([\d\*])—([\d\*])/, '\\1--\\2')
    text.gsub(/([IVX\*])—([\*IVX\*])/, '\\1--\\2')
  end

  def self.footnotes(text, bracket = false, letter = false)
    rest, *note_texts = footnotes_array(text)
    notes = note_texts.collect do |full|
      id, t = footnote_id(full, bracket, letter)
      {full: full, id: id, text: t, 
       type: footnote_type(id),
       placehold: placehold(id, bracket)}
    end

    # insert number notes
    rest = insert_notes(rest, notes, ['\footnote', '\footnoteA'])
    # insert asterics notes
    insert_notes(rest, notes, ['\footnote*'])
  end

  def self.footnotes_bracket(text)
    footnotes(text, true, false)
  end

  def self.footnotes_letter(text)
    footnotes(text, false, true)
  end

  def self.footnotes_simple(text)
    footnotes(text, false, false)
  end

  def self.footnote_type(id)
    return '\footnote*' if id.include?('*')
    return '\footnoteA' if id =~ /\p{L}/
    '\footnote'
  end

  def self.placehold(id, bracket)
    br = bracket ? '\s*?\)?' : ''
    Regexp.new ('([^\d\*])\s*' + Regexp.quote(id) + br + '(([^\d\*aа]|\Z))')
  end

  def self.insert_notes(text, notes, types)
    rest = []
    notes.each do |note|
      # only number notes
      next unless types.include? note[:type]
      # if can't find
      if text.scan(note[:placehold]).count != 1
        text += "\n\n" + note[:full]
        next
      end
      # random id
      note[:id] = ('a'..'z').to_a.shuffle.join
      text = text.gsub(note[:placehold], "#{$1}" + note[:id] + "#{$2}")
      rest << note
    end
    rest.each do |note|
      text = text.gsub(note[:id], note[:type] + "{\n" + note[:text] + "\n}")
    end
    text
  end

  def self.footnote_id(footnote, bracket=false, letter=false)
    id = footnote[/[\d\*]+/]
    id = footnote[/[\d\*]+\p{L}?/] if letter
    text = footnote.gsub(/\A\s*#{Regexp.escape(id)}\s*/, '').strip
    text = text.gsub(/\A\s*\)\s*/, '') if bracket
    return id, text
  end

  def self.footnotes_array(text)
    text.split(/(?=\n\n[\d\*]+)\s*/)
  end
end
