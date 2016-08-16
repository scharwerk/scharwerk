class Page < ActiveRecord::Base
  
  def self.path_join(path)
  	File.join(Rails.configuration.x.data.text_path, path)
  end

  def save_to_file()
  	File.write(self.class.path_join(path), text)
  end

  def self.load_from_file(path)
  	page = where(path: path).first_or_create
  	page.text = File.read(self.path_join(path))
  	page.save()
  end
end
