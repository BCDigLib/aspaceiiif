require 'aspaceiiif/config'

describe Aspaceiiif::Config do
  it "loads a config file" do 
    expect(Aspaceiiif::Config.load).to be_a(Hash)
  end
end