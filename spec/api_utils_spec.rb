require 'aspaceiiif/api_utils'

describe Aspaceiiif::APIUtils do

  describe "#get_record(uri_suffix)" do
    let(:conn) { Aspaceiiif::APIUtils.new }

    context "given a valid endpoint" do
      it "returns a hash" do
        expect(conn.get_record('/repositories/2/digital_objects/1596')).to be_a(Hash)
      end
    end
  end
end