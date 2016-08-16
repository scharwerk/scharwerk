require 'rails_helper'

RSpec.describe Page, type: :model do
  def path_join(path)
    File.join(Rails.configuration.x.data.text_path, path)
  end

  after(:all) do
  	Dir[path_join("**/*.txt")].each do |file|
      File.delete(file)
    end
  end

  it "saves text to file" do
  	page = Page.create(path: "1/2.txt", text: "book 1 page 1")
  	page.save_to_file()
  	expect(File.read(path_join("1/2.txt"))).to eq("book 1 page 1")
  end

  it "loads file to new page" do
  	File.write(path_join("1/3.txt"), "book 1 page 3")
  	Page.load_from_file("1/3.txt")
  	expect(Page.where(path: "1/3.txt").first.text).to eq("book 1 page 3")
  end

  it "updates page text from file" do
  	Page.create(path: "1/4.txt", text: "old text")
  	File.write(path_join("1/4.txt"), "book 1 page 4")
  	Page.load_from_file("1/4.txt")
  	expect(Page.where(path: "1/4.txt").first.text).to eq("book 1 page 4")  	
  end
end
