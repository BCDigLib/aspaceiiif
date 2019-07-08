require 'aspaceiiif/api_utils'

describe ASpaceIIIF::APIUtils do
  let(:conn) { ASpaceIIIF::APIUtils.new }

  describe "#get_record(uri_suffix)" do
    context "given a valid endpoint" do
      it "returns a hash" do
        expect(conn.get_record('/repositories/2/digital_objects/1596')).to be_a(Hash)
      end
    end
  end

  describe "#find_digital_objects(resource_id)" do
    it "returns an array" do
      expect(conn.find_digital_objects('122')).to be_a(Array)
    end

    it "finds all associated digital objects" do
      expect(conn.find_digital_objects('122').length).to eq(7)
      expect(conn.find_digital_objects('122')).to eq(['1703', '1704', '1705', '1706', '1707', '1708', '1709'])
    end
  end
end
