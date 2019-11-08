# usage
#
# ruby tex.rb dots ../db/git/tex/franko/\*.tex
# ruby tex.rb index_n_fix ../db/git/tex/i/_\*.tex

require_relative '../lib/tex_processing'

method, path = ARGV

Dir[path].each do |file|
  puts(file)
  tex = TexProcessing.method(method).call(File.read(file))
  File.write(file, tex)
end
