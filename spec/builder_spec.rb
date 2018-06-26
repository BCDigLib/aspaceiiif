require 'aspaceiiif/builder'

describe ASpaceIIIF::Builder do
  let(:builder) { ASpaceIIIF::Builder.new('1596') }
  let(:metadata) { ASpaceIIIF::Metadata.new('1596') }

  describe "#generate_manifest" do
    let(:manifest) { builder.generate_manifest(metadata) }

    it "has a valid ID attribute" do
      expect(manifest["@id"]).to be_instance_of(String)
      expect(manifest["@id"]).to match(/https:\/\/library\.bc\.edu\/(BC)\d{4}_\d{3}_.+\.json|(MS)\d{4}_\d{3}_.+\.json/)
    end

    it "contains the record title" do
      expect(manifest["label"]).to eq(metadata.title)
    end

    it "includes rights information in the attribution attribute" do
      expect(manifest["attribution"]).to eq(metadata.rights_statement)
    end

    it "contains a metadata block" do
      expect(manifest["metadata"]).to be_instance_of(Array)
      expect(manifest["metadata"].length).to be > 0
    end

    it "includes a handle in the metadata block" do
      expect(manifest["metadata"][0][:handle]).to include("hdl.handle.net")
    end

    it "includes a preferred citation in the metadata block" do
      expect(manifest["metadata"][1][:label]).to eq("Preferred Citation")
    end

    it "includes all expected values in the preferred citation" do
      expect(manifest["metadata"][1][:value]).to include(metadata.title && metadata.resource_id && metadata.owner && metadata.handle)
    end
  end
end