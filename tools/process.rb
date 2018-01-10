# usage
#
# ruby process.rb capitalize_heading ../text/i/*.txt
#
require_relative 'text_processing'

method, path = ARGV

Dir[path].each do |file|
  t = TextProcessing.new(File.read(file))
  text = t.method(method).call
  File.write(path, text)
end
