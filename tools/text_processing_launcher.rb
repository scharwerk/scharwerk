require_relative 'text_processing'

class TextProcessingLauncher
  def initialize(path_to_folder)
    @path_to_folder = path_to_folder
  end

  def read_text(path_to_file)
    File.read(path_to_file)
  end

  def write_to_text(path_to_file, amended_text)
    File.write(path_to_file, amended_text)
  end

  def upgrade_text
    Dir["#{@path_to_folder}/*"].each do |text_path|
      text1 = read_text(text_path)
      text_processing = TextProcessing.new(text1)
      text_processing.change_quotes
      text_processing.replace_double_chars
      text_processing.add_empty_line
      text_processing.remove_line_breaks
      text_processing.remove_trailing_whitespace
      amended_text = text_processing.capitalize_heading
      write_to_text(text_path, amended_text)
    end
  end
end

launcher = TextProcessingLauncher.new('iii.1')
launcher.upgrade_text
