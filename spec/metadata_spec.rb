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

  describe "#title" do
    it "returns a string" do
      expect(metadata.title).to be_instance_of(String)
      expect(metadata.title.length).to be > 0
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

  describe "#filenames" do
    it "returns an array" do 
      expect(metadata.filenames).to be_instance_of(Array)
      expect(metadata.filenames.length).to be > 0
    end

    it "includes JP2s" do
      expect(metadata.filenames.all? { |fname| fname.include?('jp2') }).to be true
    end

    it "contains no duplicates" do
      expect(metadata.filenames.uniq == metadata.filenames).to be true
    end
  end
end