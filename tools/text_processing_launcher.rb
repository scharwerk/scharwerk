require_relative 'text_processing'

class TextProcessingLauncher
  def initialize(path_to_file)
    @path_to_file = path_to_file
  end


  def read_text
    File.read(@path_to_file)
  end

  def write_to_text(amended_text)
    File.write(@path_to_file, amended_text)
  end
end

launcher = TextProcessingLauncher.new('path.txt')
text1 = launcher.read_text
text_processing = TextProcessing.new(text1)
text_processing.change_quotes
amended_text = text_processing.capitalize_heading
launcher.write_to_text(amended_text)
