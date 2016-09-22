# coding: utf-8
#require_relative '../lib/pdf_interface'
require 'pdf_interface'

RSpec.describe PDFInterface do
  before(:each) do
    @pdf = PDFInterface.new("mikolov.pdf")
    @pdf.process
  end
  
  xit "extracts the title from a pdf paper" do    
    expect(@pdf.title).to eq("Bag of Tricks for Efﬁcient Text Classiﬁcation")
  end

  xit "extracts the authors from a pdf paper" do
    expect(@pdf.authors).to eq("Armand Joulin, Edouard Grave, Piotr Bojanowski, Tomas Mikolov")
  end

  it "extracts the abstract from a pdf paper" do
    expect(@pdf.abstract[0..28]).to eq("In this work, we explore ways")
  end

  it "extracts the body" do
    expect(@pdf.body[-32..-1]).to eq("A comparison of event models for")
  end
  it "extracts the title even if it's not the first sentence"

  it "gets the first 3000 characters if cannot find the abstract"

  it "adds a log to each pdf to remember how the extraction went"

  it "gets the name of the file" do
    expect(@pdf.filename).to eq("mikolov.pdf")
  end
end
