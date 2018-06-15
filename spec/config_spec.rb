require 'aspaceiiif/config'

describe ASpaceIIIF::Config do
  it "loads a config file" do 
    expect(ASpaceIIIF::Config.load).to be_a(Hash)
  end
end
