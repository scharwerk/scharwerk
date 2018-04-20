# usage
#
# ruby process.rb capitalize_heading .../db/git/text/i/\*.txt
#
require_relative '../lib/text_processing'

method, path = ARGV

Dir[path].each do |file|
  t = TextProcessing.new(File.read(file))
  text = t.method(method).call
  File.write(file, text)
end
