require 'aspaceiiif/records'

describe Aspaceiiif::Records do
  let(:records) { Aspaceiiif::Records.new('1596') }

  context "given an instance of the Records class" do
    describe "#digital_object" do
      it "returns digital object JSON" do
        expect(records.digital_object["jsonmodel_type"]).to eq "digital_object"
      end
    end

    describe "#digital_object_tree" do
      it "returns digital object tree JSON" do
        expect(records.digital_object_tree["jsonmodel_type"]).to eq "digital_object_tree"
      end
    end

    describe "#archival_object" do
      it "returns archival object JSON" do
        expect(records.archival_object["jsonmodel_type"]).to eq "archival_object"
      end
    end

    describe "#resource" do
      it "returns resource JSON" do
        expect(records.resource["jsonmodel_type"]).to eq "resource"
      end
    end
  end
end