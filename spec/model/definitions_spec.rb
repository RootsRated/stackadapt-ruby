require "spec_helper"

class StackAdapt::FakeModel
  include StackAdapt::Model::Definitions
  extend StackAdapt::Model::Definitions::ClassMethods
end

class StackAdapt::AssociatedFakeModel
  include StackAdapt::Model::Definitions
  extend StackAdapt::Model::Definitions::ClassMethods
end

describe StackAdapt::Model::Definitions do
  let(:attrs) { {} }
  subject(:model) { StackAdapt::FakeModel.new(attrs) }

  describe "#attr_reader(attrs)" do
    context "when one attr is passed" do
      let(:attrs) { { attr: :attr_value } }
      before do
        StackAdapt::FakeModel.class_eval do
          attr_reader :attr
        end
      end

      describe "reader method" do
        it "should define a reader method on the model" do
          expect(subject.respond_to?(:attr)).to be_truthy
        end

        it "should return the value of the attr from initialization" do
          expect(subject.public_send(:attr)).to eq(:attr_value)
        end
      end

      describe "inflection method" do
        it "should define an inflection method on the model" do
          expect(subject.respond_to?(:attr?)).to be_truthy
        end

        context "when the value of the attr from initialization is present" do
          let(:attrs) { { attr: :attr_value } }

          it "should return true" do
            expect(subject.public_send(:attr?)).to be_truthy
          end
        end

        context "when the value of the attr from initialization is not present" do
          let(:attrs) { { attr: nil } }

          it "should return false" do
            expect(subject.public_send(:attr?)).to be_falsey
          end
        end
      end
    end

    context "when multiple attrs are passed" do
      let(:attrs) { { attr1: :attr1_value, attr2: :attr2_value } }
      before do
        StackAdapt::FakeModel.class_eval do
          attr_reader :attr1, :attr2
        end
      end

      describe "reader method" do
        it "should define a reader method for each attr on the model", :aggregate_failures do
          expect(subject.respond_to?(:attr1)).to be_truthy
          expect(subject.respond_to?(:attr2)).to be_truthy
        end

        it "should return the values of the attrs from initialization", :aggregate_failures do
          expect(subject.public_send(:attr1)).to eq(:attr1_value)
          expect(subject.public_send(:attr2)).to eq(:attr2_value)
        end
      end

      describe "inflection method" do
        it "should define an inflection method for each attr on the model", :aggregate_failures do
          expect(subject.respond_to?(:attr1?)).to be_truthy
          expect(subject.respond_to?(:attr2?)).to be_truthy
        end

        context "when the value of the attrs from initialization are present" do
          let(:attrs) { { attr1: :attr1_value, attr2: :attr2_value } }

          it "should return true", :aggregate_failures do
            expect(subject.public_send(:attr1?)).to be_truthy
            expect(subject.public_send(:attr2?)).to be_truthy
          end
        end

        context "when the value of the attrs from initialization aren't present" do
          let(:attrs) { { attr1: nil, attr2: nil } }

          it "should return false", :aggregate_failures do
            expect(subject.public_send(:attr1?)).to be_falsey
            expect(subject.public_send(:attr2?)).to be_falsey
          end
        end
      end
    end
  end

  describe "#attr_accessor(attrs)" do
    context "when one attr is passed" do
      let(:attrs) { { attr: nil } }

      describe "reader and inflection methods" do
        it "should call #attr_reader with the attr" do
          expect(subject.class).to receive(:attr_reader).with(:attr)
          StackAdapt::FakeModel.class_eval { attr_accessor :attr }
        end
      end

      describe "writer method" do
        before do
          StackAdapt::FakeModel.class_eval do
            attr_accessor :attr
          end
        end

        it "should define a writer method on the model" do
          expect(subject.respond_to?(:attr=)).to be_truthy
        end

        context "when a value is passed to the writer method" do
          let(:new_value) { :new_attr_value }
          before do
            subject.attr = new_value
          end

          it "should update the attr on the model" do
            expect(subject.public_send(:attr)).to eq(new_value)
          end
        end
      end
    end

    context "when multiple attrs are passed" do
      let(:attrs) { { attr1: nil, attr2: nil } }

      describe "reader and inflection methods" do
        it "should call #attr_reader with the attrs" do
          expect(subject.class).to receive(:attr_reader).with(:attr1, :attr2)
          StackAdapt::FakeModel.class_eval { attr_accessor :attr1, :attr2 }
        end
      end

      describe "writer methods" do
        before do
          StackAdapt::FakeModel.class_eval do
            attr_accessor :attr1, :attr2
          end
        end

        it "should define writer methods for each attr on the model", :aggregate_failures do
          expect(subject.respond_to?(:attr1=)).to be_truthy
          expect(subject.respond_to?(:attr2=)).to be_truthy
        end

        context "when a value is passed to the writer methods" do
          let(:new_value1) { :new_attr1_value }
          let(:new_value2) { :new_attr2_value }
          before do
            subject.attr1 = new_value1
            subject.attr2 = new_value2
          end

          it "should update the attrs on the model", :aggregate_failures do
            expect(subject.public_send(:attr1)).to eq(new_value1)
            expect(subject.public_send(:attr2)).to eq(new_value2)
          end
        end
      end
    end
  end

  describe "#nested_attr_reader(attr, *key_path)" do
    let(:attrs) { { nested_attr_parent: { nested_attr: :nested_attr_value } } }
    before do
      StackAdapt::FakeModel.class_eval do
        nested_attr_reader :nested_attr, :nested_attr_parent
      end
    end

    describe "reader method" do
      it "should define a reader method on the model" do
        expect(subject.respond_to?(:nested_attr)).to be_truthy
      end

      it "should return the value of the nested_attr from initialization" do
        expect(subject.public_send(:nested_attr)).to eq(:nested_attr_value)
      end
    end

    describe "inflection method" do
      it "should define an inflection method on the model" do
        expect(subject.respond_to?(:nested_attr?)).to be_truthy
      end

      context "when the value of the nested attr from initialization is present" do
        let(:attrs) { { nested_attr_parent: { nested_attr: :nested_attr_value } } }

        it "should return true" do
          expect(subject.public_send(:nested_attr?)).to be_truthy
        end
      end

      context "when the value of the nested attr from initialization is not present" do
        let(:attrs) { { nested_attr_parent: { nested_attr: nil } } }

        it "should return false" do
          expect(subject.public_send(:nested_attr?)).to be_falsey
        end
      end
    end
  end

  describe "#nested_attr_accessor(attr, *key_path)" do
    let(:attrs) { { nested_attr_parent: { nested_attr: nil } } }

    describe "reader and inflection methods" do
      it "should call #nested_attr_reader with the attr and key path" do
        expect(subject.class).to receive(:nested_attr_reader).with(:nested_attr, :nested_attr_parent)
        StackAdapt::FakeModel.class_eval { nested_attr_reader :nested_attr, :nested_attr_parent }
      end
    end

    describe "writer method" do
      before do
        StackAdapt::FakeModel.class_eval do
          nested_attr_accessor :nested_attr, :nested_attr_parent
        end
      end

      it "should define a writer method on the model" do
        expect(subject.respond_to?(:nested_attr=)).to be_truthy
      end

      context "when a value is passed to the writer method" do
        let(:new_value) { :new_nested_attr_value }
        before { subject.nested_attr = new_value }

        it "should update the attr on the model" do
          expect(subject.public_send(:nested_attr)).to eq(new_value)
        end

        context "when another attr exists under the same parent" do
          let(:attrs) { { nested_attr_parent: { nested_attr1: nil, nested_attr2: nil } } }
          before do
            StackAdapt::FakeModel.class_eval do
              nested_attr_accessor :nested_attr, :nested_attr_parent
              nested_attr_accessor :nested_attr2, :nested_attr_parent
            end

            subject.nested_attr2 = new_value
          end

          it "should not update the other attr under the same parent", :aggregate_failures do
            expect(subject.public_send(:nested_attr)).to eq(new_value)
            expect(subject.public_send(:nested_attr2)).to eq(new_value)
          end
        end
      end
    end
  end

  describe "#date_attr_reader(attrs)" do
    context "when one attr is passed" do
      let(:date_attr_value) { DateTime.now.to_s }
      let(:attrs) { { date_attr: date_attr_value } }
      before do
        StackAdapt::FakeModel.class_eval do
          date_attr_reader :date_attr
        end
      end

      describe "reader method" do
        it "should define a reader method on the model" do
          expect(subject.respond_to?(:date_attr)).to be_truthy
        end

        it "should return the value of the attr from initialization" do
          expect(subject.public_send(:date_attr)).to be_a(DateTime)
          expect(subject.public_send(:date_attr)).to be_within(1).of(DateTime.parse(date_attr_value))
        end
      end

      describe "inflection method" do
        it "should define an inflection method on the model" do
          expect(subject.respond_to?(:date_attr?)).to be_truthy
        end

        context "when the value of the attr from initialization is present" do
          let(:attrs) { { date_attr: date_attr_value } }

          it "should return true" do
            expect(subject.public_send(:date_attr?)).to be_truthy
          end
        end

        context "when the value of the attr from initialization is not present" do
          let(:attrs) { { date_attr: nil } }

          it "should return false" do
            expect(subject.public_send(:date_attr?)).to be_falsey
          end
        end
      end
    end

    context "when multiple date attrs are passed" do
      let(:date_attr1_value) { DateTime.now.to_s }
      let(:date_attr2_value) { DateTime.now.to_s }
      let(:attrs) { { date_attr1: date_attr1_value, date_attr2: date_attr2_value } }
      before do
        StackAdapt::FakeModel.class_eval do
          date_attr_reader :date_attr1, :date_attr2
        end
      end

      describe "reader method" do
        it "should define a reader method for each attr on the model", :aggregate_failures do
          expect(subject.respond_to?(:date_attr1)).to be_truthy
          expect(subject.respond_to?(:date_attr2)).to be_truthy
        end

        it "should return the values of the attrs from initialization", :aggregate_failures do
          expect(subject.public_send(:date_attr1)).to be_a(DateTime)
          expect(subject.public_send(:date_attr1)).to be_within(1).of(DateTime.parse(date_attr1_value))
          expect(subject.public_send(:date_attr1)).to be_a(DateTime)
          expect(subject.public_send(:date_attr2)).to be_within(1).of(DateTime.parse(date_attr2_value))
        end
      end

      describe "inflection method" do
        it "should define an inflection method for each attr on the model", :aggregate_failures do
          expect(subject.respond_to?(:date_attr1?)).to be_truthy
          expect(subject.respond_to?(:date_attr2?)).to be_truthy
        end

        context "when the value of the attrs from initialization are present" do
          let(:attrs) { { date_attr1: date_attr1_value, date_attr2: date_attr2_value } }

          it "should return true", :aggregate_failures do
            expect(subject.public_send(:date_attr1?)).to be_truthy
            expect(subject.public_send(:date_attr2?)).to be_truthy
          end
        end

        context "when the value of the attrs from initialization aren't present" do
          let(:attrs) { { date_attr1: nil, date_attr2: nil } }

          it "should return false", :aggregate_failures do
            expect(subject.public_send(:date_attr1?)).to be_falsey
            expect(subject.public_send(:date_attr2?)).to be_falsey
          end
        end
      end
    end
  end

  describe "#date_attr_accessor(date_attrs)" do
    context "when one date_attr is passed" do
      let(:date_attrs) { { date_attr: :date_attr_value } }

      describe "reader and inflection methods" do
        it "should call #date_attr_reader with the date_attr" do
          expect(subject.class).to receive(:date_attr_reader).with(:date_attr)
          StackAdapt::FakeModel.class_eval { date_attr_accessor :date_attr }
        end
      end

      describe "writer method" do
        before do
          StackAdapt::FakeModel.class_eval do
            date_attr_accessor :date_attr
          end
        end

        it "should define a writer method on the model" do
          expect(subject.respond_to?(:date_attr=)).to be_truthy
        end

        context "when a value is passed to the writer method" do
          let(:new_value) { DateTime.now }
          before do
            subject.date_attr = new_value
          end

          it "should update the date_attr on the model" do
            expect(subject.public_send(:date_attr)).to be_within(1).of(new_value)
          end
        end
      end
    end

    context "when multiple date_attrs are passed" do
      let(:date_attrs) { { date_attr1: DateTime.now, date_attr2: DateTime.now } }

      describe "reader and inflection methods" do
        it "should call #date_attr_reader with the date_attrs" do
          expect(subject.class).to receive(:date_attr_reader).with(:date_attr1, :date_attr2)
          StackAdapt::FakeModel.class_eval { date_attr_accessor :date_attr1, :date_attr2 }
        end
      end

      describe "writer methods" do
        before do
          StackAdapt::FakeModel.class_eval do
            date_attr_accessor :date_attr1, :date_attr2
          end
        end

        it "should define writer methods for each date_attr on the model", :aggregate_failures do
          expect(subject.respond_to?(:date_attr1=)).to be_truthy
          expect(subject.respond_to?(:date_attr2=)).to be_truthy
        end

        context "when a value is passed to the writer methods" do
          let(:new_value1) { DateTime.now }
          let(:new_value2) { DateTime.now }
          before do
            subject.date_attr1 = new_value1
            subject.date_attr2 = new_value2
          end

          it "should update the date_attrs on the model", :aggregate_failures do
            expect(subject.public_send(:date_attr1)).to be_within(1).of(new_value1)
            expect(subject.public_send(:date_attr2)).to be_within(1).of(new_value2)
          end
        end
      end
    end
  end

  describe "#object_attr_reader(attrs)" do
    let(:object_attr_value) { { obj_attr1: :obj_attr_value } }
    let(:attrs) { { object_attr: object_attr_value } }
    before do
      StackAdapt::FakeModel.class_eval do
        object_attr_reader :AssociatedFakeModel, :object_attr
      end
    end

    describe "reader method" do
      it "should define a reader method on the model" do
        expect(subject.respond_to?(:object_attr)).to be_truthy
      end

      it "should return an instance of the object attr's class" do
        expect(subject.public_send(:object_attr)).to be_a(StackAdapt::AssociatedFakeModel)
      end

      it "should instantiate the returned instance with the attr's values" do
        faked_object = StackAdapt::AssociatedFakeModel.new(object_attr_value)
        expect(StackAdapt::AssociatedFakeModel).to receive(:new).with(object_attr_value).and_return(faked_object)
        expect(subject.public_send(:object_attr)).to eq(faked_object)
      end
    end

    describe "inflection method" do
      it "should define an inflection method on the model" do
        expect(subject.respond_to?(:object_attr?)).to be_truthy
      end

      context "when the value of the attr from initialization is present" do
        let(:attrs) { { object_attr: object_attr_value } }

        it "should return true" do
          expect(subject.public_send(:object_attr?)).to be_truthy
        end
      end

      context "when the value of the attr from initialization is not present" do
        let(:attrs) { { object_attr: nil } }

        it "should return false" do
          expect(subject.public_send(:object_attr?)).to be_falsey
        end
      end
    end
  end

  describe "#object_attr_accessor(object_attrs)" do
    let(:object_attr_value) { { obj_attr1: :obj_attr_value } }
    let(:attrs) { { object_attr: nil } }

    describe "reader and inflection methods" do
      it "should call #object_attr_reader with the object_attr" do
        expect(subject.class).to receive(:object_attr_reader).with(:AssociatedFakeModel, :object_attr)
        StackAdapt::FakeModel.class_eval { object_attr_accessor :AssociatedFakeModel, :object_attr }
      end
    end

    describe "writer method" do
      before do
        StackAdapt::FakeModel.class_eval do
          object_attr_accessor :AssociatedFakeModel, :object_attr
        end
      end

      it "should define a writer method on the model" do
        expect(subject.respond_to?(:object_attr=)).to be_truthy
      end

      context "when an object is passed to the writer method" do
        before do
          subject.object_attr = StackAdapt::AssociatedFakeModel.new(object_attr_value)
        end

        it "should update the object_attr on the model with the object's attrs" do
          expect(subject.public_send(:object_attr).send(:attrs)).to eq(object_attr_value)
        end
      end
    end
  end

  describe "#collection_object_attr_reader(attrs)" do
    let(:object1_attr_value) { { obj_attr1: :obj_attr_value } }
    let(:object2_attr_value) { { obj_attr1: :obj_attr_value } }
    let(:attrs) { { collection_object_attr: [object1_attr_value, object2_attr_value] } }
    before do
      StackAdapt::FakeModel.class_eval do
        collection_object_attr_reader :AssociatedFakeModel, :collection_object_attr
      end
    end

    describe "reader method" do
      it "should define a reader method on the model" do
        expect(subject.respond_to?(:collection_object_attr)).to be_truthy
      end

      it "should return a collection" do
        expect(subject.public_send(:collection_object_attr)).to be_an(Array)
      end

      it "should instantiate the returned instances with the attr's values" do
        faked_object1 = StackAdapt::AssociatedFakeModel.new(object1_attr_value)
        faked_object2 = StackAdapt::AssociatedFakeModel.new(object2_attr_value)

        expect(StackAdapt::AssociatedFakeModel).to receive(:new).with(object1_attr_value).once.and_return(faked_object1)
        expect(StackAdapt::AssociatedFakeModel).to receive(:new).with(object2_attr_value).once.and_return(faked_object2)

        expect(subject.public_send(:collection_object_attr)).to include(faked_object1, faked_object2)
      end
    end

    describe "inflection method" do
      it "should define an inflection method on the model" do
        expect(subject.respond_to?(:collection_object_attr?)).to be_truthy
      end

      context "when the attr includes objects from initialization" do
        let(:attrs) { { collection_object_attr: [object1_attr_value, object2_attr_value] } }

        it "should return true" do
          expect(subject.public_send(:collection_object_attr?)).to be_truthy
        end
      end

      context "when the value of the attr from initialization is empty" do
        let(:attrs) { { collection_object_attr: [] } }

        it "should return false" do
          expect(subject.public_send(:collection_object_attr?)).to be_falsey
        end
      end
    end
  end

  describe "#collection_object_attr_accessor(object_attrs)" do
    let(:object1_attr_value) { { obj_attr1: :obj_attr_value } }
    let(:object2_attr_value) { { obj_attr1: :obj_attr_value } }
    let(:attrs) { { collection_object_attr: nil } }

    describe "reader and inflection methods" do
      it "should call #object_attr_reader with the object_attr" do
        expect(subject.class).to receive(:collection_object_attr_reader).with(:AssociatedFakeModel, :collection_object_attr)
        StackAdapt::FakeModel.class_eval { collection_object_attr_accessor :AssociatedFakeModel, :collection_object_attr }
      end
    end

    describe "writer method" do
      before do
        StackAdapt::FakeModel.class_eval do
          collection_object_attr_accessor :AssociatedFakeModel, :collection_object_attr
        end
      end

      it "should define a writer method on the model" do
        expect(subject.respond_to?(:collection_object_attr=)).to be_truthy
      end

      context "when an object is passed to the writer method" do
        let(:faked_object1) { StackAdapt::AssociatedFakeModel.new(object1_attr_value) }
        let(:faked_object2) { StackAdapt::AssociatedFakeModel.new(object2_attr_value) }

        before do
          subject.collection_object_attr = [faked_object1, faked_object2]
        end

        it "should update the object_attr on the model with the object's attrs" do
          expect(StackAdapt::AssociatedFakeModel).to receive(:new).with(object1_attr_value).once.and_return(faked_object1)
          expect(StackAdapt::AssociatedFakeModel).to receive(:new).with(object2_attr_value).once.and_return(faked_object2)

          expect(subject.public_send(:collection_object_attr)).to include(faked_object1, faked_object2)
        end
      end
    end
  end

end
