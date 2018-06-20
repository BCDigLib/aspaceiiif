require 'aspaceiiif/metadata'

describe ASpaceIIIF::Metadata do
  let(:metadata) { ASpaceIIIF::Metadata.new('1596') }

  describe "#handle" do
    it "returns a handle URI" do
      expect(metadata.handle).to include("hdl.handle.net")
    end
  end

  describe "#rights_statement" do
    it "returns a string" do
      expect(metadata.rights_statement).to be_instance_of(String)
      expect(metadata.rights_statement.length).to be > 0
    end
  end
end