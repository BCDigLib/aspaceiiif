require 'aspaceiiif/builder'

describe ASpaceIIIF::Builder do
  let(:builder) { ASpaceIIIF::Builder.new('1596') }
  let(:metadata) { ASpaceIIIF::Metadata.new('1596') }

  describe "#export_manifest" do
    let(:manifest_export) { builder.export_manifest }

    it "outputs a manifest" do
      expect(manifest_export["@type"]).to eq("sc:Manifest")
    end

    it "conforms to v2 of the IIIF presentation API" do
      expect(manifest_export["@context"]).to eq("http://iiif.io/api/presentation/2/context.json")
    end

    it "includes a sequences block" do
      expect(manifest_export["sequences"]).to be_instance_of(Array)
      expect(manifest_export["sequences"].length).to be > 0
    end

    it "contains at least one canvas in the sequences block" do
      expect(manifest_export["sequences"][0]["@type"]).to eq("sc:Canvas")
    end

    it "includes a structures block" do
      expect(manifest_export["structures"]).to be_instance_of(Array)
      expect(manifest_export["sequences"].length).to be > 0 
    end

    it "contains at least one range in the structures block" do
      expect(manifest_export["structures"][0]["@type"]).to eq("sc:Range")
    end
  end

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

  describe "#generate_canvas" do
    let(:canvas) { builder.generate_canvas(metadata.filenames[0], metadata.filenames[0].chomp(".jp2"), 1) }

    it "outputs a canvas" do
      expect(canvas["@type"]).to eq("sc:Canvas")
    end
  end

  describe "#generate_image_resource" do
    let(:image_resource) { builder.generate_image_resource(metadata.filenames[0]) }

    it "returns an image resource" do
      expect(image_resource["@type"]).to eq("dctypes:Image")
    end
  end

  describe "#generate_range" do
    let(:range) { builder.generate_range(metadata.filenames[0], metadata.filenames[0].chomp(".jp2"), 1) }

    it "outputs a range" do
      expect(range["@type"]).to eq("sc:Range")
    end
  end
end