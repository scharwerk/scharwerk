class Page < ActiveRecord::Base
  
  def save_to_file()
  	File.open(File.join(Rails.configuration.x.data.text_path, path), 'w') do |f|
  		f.puts text
	end
  end
end
