require 'aspaceiiif/builder'

describe ASpaceIIIF::Builder do
  # Japanese prints Chushingura used as example of standard dig obj for legacy 
  # manuscript collections
  let(:legacy_builder) { ASpaceIIIF::Builder.new('1596') }
  let(:legacy_metadata) { ASpaceIIIF::Metadata.new('1596') }

  # CCC South Boston High School monitor reports used to test edge cases in which 
  # the filename includes a folder number
  let(:edge_case_builder) { ASpaceIIIF::Builder.new('1708') }
  let(:edge_case_metadata) { ASpaceIIIF::Metadata.new('1708') }

  # Newer digital objects use the archival object PK instead of a ref number in
  # their component unique IDs. Here we are using a digital object from the 
  # Joseph J. Williams ethnological collection as our standard test fixture.
  let(:builder) { ASpaceIIIF::Builder.new('1746') }
  let(:metadata) { ASpaceIIIF::Metadata.new('1746') }

  describe "#generate_manifest" do
    let(:manifest) { builder.generate_manifest }

    it "outputs a manifest" do
      expect(manifest["@type"]).to eq("sc:Manifest")
    end

    it "includes a sequences block" do
      expect(manifest["sequences"]).to be_instance_of(Array)
      expect(manifest["sequences"].length).to be > 0
    end

    it "contains at least one canvas in the sequences block" do
      expect(manifest["sequences"][0]["canvases"][0]["@type"]).to eq("sc:Canvas")
    end

    it "includes a structures block" do
      expect(manifest["structures"]).to be_instance_of(Array)
      expect(manifest["sequences"].length).to be > 0 
    end

    it "contains at least one range in the structures block" do
      expect(manifest["structures"][0]["@type"]).to eq("sc:Range")
    end

    it "has a valid ID attribute" do
      expect(manifest["@id"]).to match(/https:\/\/library\.bc\.edu\/(BC)\d{4}_\d{3}_.+\.json|(MS)\d{4}_\d{3}_.+\.json/)
    end

    it "contains the record title" do
      expect(manifest["label"]).to eq(metadata.title)
    end

    it "includes usage information in the attribution attribute" do
      expect(manifest["attribution"]).to eq(metadata.use_statement)
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
    let(:canvas) { builder.generate_canvas(metadata.component_labels_filenames[0], metadata.component_labels_filenames[0].chomp(".jp2"), 1) }
    let(:edge_case_canvas) { edge_case_builder.generate_canvas(edge_case_metadata.component_labels_filenames[0], edge_case_metadata.component_labels_filenames[0].chomp(".jp2"), 1) }

    it "outputs a canvas" do
      expect(canvas["@type"]).to eq("sc:Canvas")
    end

    it "outputs a normal canvas ID" do
      expect(canvas["@id"]).to eq("/canvas/0000")
    end

    it "includes folder number in canvas IDs when applicable" do
      expect(edge_case_canvas["@id"]).to eq("/canvas/001_001")
    end
  end

  describe "#generate_image_resource" do
    let(:image_resource) { builder.generate_image_resource(metadata.component_labels_filenames[0]) }

    it "returns an image resource" do
      expect(image_resource["@type"]).to eq("dctypes:Image")
    end
  end

  describe "#generate_range" do
    let(:range) { builder.generate_range(metadata.component_labels_filenames[0], metadata.component_labels_filenames[0].chomp(".jp2"), 1) }
    let(:edge_case_range) { edge_case_builder.generate_range(edge_case_metadata.component_labels_filenames[0], edge_case_metadata.component_labels_filenames[0].chomp(".jp2"), 1) }

    it "outputs a range" do
      expect(range["@type"]).to eq("sc:Range")
    end

    it "ranges include a normal canvas ID" do
      expect(range["canvases"][0]).to eq("/canvas/0000")
    end

    it "ranges include folder number canvas IDs when applicable" do
      expect(edge_case_range["canvases"][0]).to eq("/canvas/001_001")
    end
  end
end