# usage
#
# ruby tex.rb dots ../db/git/tex/franko/\*.tex
#
require_relative '../lib/tex_processing'

method, path = ARGV

Dir[path].each do |file|
  tex = TexProcessing.method(method).call(File.read(file))
  File.write(file, tex)
end
