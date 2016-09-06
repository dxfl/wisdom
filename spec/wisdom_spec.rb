# coding: utf-8
require_relative '../wisdom'

RSpec.describe Wisdom do
  before(:each) do
    @wisdom = Wisdom.new("mikolov.pdf")
    @wisdom.process
  end
  
  it "extracts the title from a pdf paper" do
    
    expect(@wisdom.title).to eq("Bag of Tricks for Efﬁcient Text Classiﬁcation")
  end

  it "extracts the authors from a pdf paper" do
    expect(@wisdom.authors).to eq("Armand Joulin, Edouard Grave, Piotr Bojanowski, Tomas Mikolov")
  end

end
