require 'aspaceiiif/metadata'

describe ASpaceIIIF::Metadata do
  let(:metadata) { ASpaceIIIF::Metadata.new('1596') }

  describe "#handle" do
    it "returns a handle URI" do
      expect(metadata.handle).to include("hdl.handle.net")
    end
  end

  describe "#use_statement" do
    it "returns a string" do
      expect(metadata.use_statement).to be_instance_of(String)
      expect(metadata.use_statement.length).to be > 0
    end
  end

  describe "#title" do
    it "returns a string" do
      expect(metadata.title).to be_instance_of(String)
      expect(metadata.title.length).to be > 0
    end

    context "given a non-null host_title" do
      it "returns host_title as part of title" do
        expect(metadata.title).to include(metadata.host_title)
      end
    end
  end

  describe "#host_title" do
    it "returns a string" do
      expect(metadata.host_title).to be_instance_of(String)
      expect(metadata.host_title.length).to be > 0
    end
  end

  describe "#resource_id" do
    it "returns a correctly formatted resource identifier" do
      expect(metadata.resource_id).to match(/(BC)\.\d{4}\.\d{3}|(MS)\.\d{4}\.\d{3}/)
    end
  end

  describe "#component_id" do
    it "returns a BC or MS number" do
      expect(metadata.component_id).to be_instance_of(String)
      expect(metadata.component_id).to match(/(BC)\d{4}_\d{3}_.+|(MS)\d{4}_\d{3}_.+/)
    end
  end

  describe "#creator" do
    context "given a record with a creator" do
      it "returns a string" do
        expect(metadata.creator).to be_instance_of(String)
        expect(metadata.creator.length).to be > 0
      end
    end
  end

  describe "#owner" do
    it "returns a string that includes 'Burns Library'" do
      expect(metadata.owner).to be_instance_of(String)
      expect(metadata.owner.length).to be > 0
      expect(metadata.owner).to include("Burns Library")
    end
  end

  describe "#component_labels" do
    #let(:multiple_manifestations) { ASpaceIIIF::Metadata.new('2219') }

    it "returns an array" do 
      expect(metadata.component_labels).to be_instance_of(Array)
      expect(metadata.component_labels.length).to be > 0
    end

    it "includes labels that conform to collection naming conventions" do
      expect(metadata.component_labels.all? { |fname| fname.include?('MS' || 'BC') }).to be true
    end

    it "contains no duplicates" do
      expect(metadata.component_labels.uniq == metadata.component_labels).to be true
    end

    #it "does not include manifestation indicators in the filenames" do
    #  expect(multiple_manifestations.component_labels.any? { |fname| fname.include?('_INT') }).to be false
    #  expect(multiple_manifestations.component_labels.any? { |fname| fname.include?('_MAS') }).to be false
    #end
  end
end
