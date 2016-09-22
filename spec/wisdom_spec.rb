# coding: utf-8
require_relative '../wisdom'

RSpec.describe Wisdom do
  before(:each) do
    @wisdom = Wisdom.new("mikolov.pdf")
    @wisdom.process
  end
  
  xit "extracts the title from a pdf paper" do    
    expect(@wisdom.title).to eq("Bag of Tricks for Efﬁcient Text Classiﬁcation")
  end

  xit "extracts the authors from a pdf paper" do
    expect(@wisdom.authors).to eq("Armand Joulin, Edouard Grave, Piotr Bojanowski, Tomas Mikolov")
  end

  it "extracts the abstract from a pdf paper" do
    expect(@wisdom.abstract[0..28]).to eq("In this work, we explore ways")
  end

  it "extracts the body" do
    expect(@wisdom.body[-32..-1]).to eq("A comparison of event models for")
  end
  it "extracts the title even if it's not the first sentence"

  it "gets the first 3000 characters if cannot find the abstract"

  it "adds a log to each pdf to remember how the extraction went"

  it "gets the name of the file" do
    expect(@wisdom.filename).to eq("mikolov.pdf")
  end
end
