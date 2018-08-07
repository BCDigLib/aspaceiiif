require 'aspaceiiif/records'

describe ASpaceIIIF::Records do
  let(:records) { ASpaceIIIF::Records.new('1596') }

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

  describe "#digital_object_components" do
    it "returns an array of digital object component JSON" do
      expect(records.digital_object_components).to be_instance_of(Array)
      expect(records.digital_object_components.all? { |comp| comp["jsonmodel_type"] == "digital_object_component" }).to be true
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

  describe "#linked_agent" do
    context "given a record set with a linked agent who is a creator" do
      it "returns agent_person JSON" do
        expect(records.linked_agent["jsonmodel_type"]).to eq "agent_person"
      end
    end
  end
end