require 'aspaceiiif/builder'

describe ASpaceIIIF::Builder do
  let(:builder) { ASpaceIIIF::Builder.new }

  describe "#build_manifest(dig_obj_id)" do
    context "given a digital object PK" do
      it "finds a handle in the digital_object_id property" do
        expect(builder.build_manifest('1596')["digital_object_id"]).to include? "hdl.handle.net"
      end
    end
  end
end
