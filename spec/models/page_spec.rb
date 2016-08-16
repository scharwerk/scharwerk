require 'rails_helper'

RSpec.describe Page, type: :model do
  it "saves text to file" do
  	page = Page.create(path: "1/2.txt", text: "book 1 page 1")
  	page.save_to_file()
  	File.read(File.join(Rails.configuration.x.data.text_path, "1/2.txt")).should match "book 1 page 1"
  end
end
