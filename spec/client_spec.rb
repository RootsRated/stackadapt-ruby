require "spec_helper"

describe StackAdapt::Client do
  let(:api_token) { "super-secret-api_token" }
  let(:api_version) { 2 }
  subject { StackAdapt::Client.new(api_token: api_token, api_version: api_version) }

  shared_examples_for "stackadapt_initalizer" do
    describe "#api_token" do
      it "should set the api_token" do
        expect(subject.api_token).to eq(api_token)
      end
    end

    describe "#api_version" do
      it "should set the api_version" do
        expect(subject.api_version).to eq(api_version)
      end
    end
  end

  describe "#initialize" do
    context "when initialization is passed a block" do
      include_examples "stackadapt_initalizer" do
        subject do
          StackAdapt::Client.new do |client|
            client.api_token   = api_token
            client.api_version = api_version
          end
        end
      end
    end

    context "when initialization is passed an options hash" do
      include_examples "stackadapt_initalizer" do
        subject do
          StackAdapt::Client.new(
            api_token:   api_token,
            api_version: api_version,
          )
        end
      end
    end
  end
end
