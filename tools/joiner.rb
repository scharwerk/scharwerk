# usage
#
# ruby joiner.rb ../db/git/tex/franko/ parts.txt franko
#
require_relative '../lib/joiner'

path, config_file, index = ARGV

config = File.read(File.join(path, config_file))
Joiner.join(path, config, index)
