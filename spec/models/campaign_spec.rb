require "spec_helper"

describe StackAdapt::Campaign do
  describe "#save" do
    context "when the model has an id" do
      before do
        allow(subject).to receive(:id).and_return(123)
        allow(subject).to receive(:id?).and_return(true)
      end

      it "should call #save_and_update" do
        expect(subject).to receive(:save_and_update).and_return(true)
        subject.save
      end
    end

    context "when the model doesn't have an id" do
      before do
        allow(subject).to receive(:id).and_return(nil)
        allow(subject).to receive(:id?).and_return(false)
      end

      it "should call #save_and_create" do
        expect(subject).to receive(:save_and_create).and_return(true)
        subject.save
      end
    end
  end
end
