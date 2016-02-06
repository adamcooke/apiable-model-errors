require 'spec_helper'

describe ApiableModelErrors do

  context "#add" do
    it "should should add errors to the API hash too" do
      errors = ActiveModel::Errors.new(ExampleClass.new)
      errors.add :example, :too_long, :count => 4
      expect(errors.errors_for_api[:example]).to be_a Array
      expect(errors.errors_for_api[:example].size).to be 1
      expect(errors.errors_for_api[:example][0][0]).to eq(:too_long)
      expect(errors.errors_for_api[:example][0][1]).to eq({:count => 4})
    end

    it "should still return the full message to keep same behaviour" do
      errors = ActiveModel::Errors.new(ExampleClass.new)
      expect(errors.add(:example, :blank)).to eq(["can't be blank"])
    end
  end

  context "#to_api_hash" do
    subject(:errors) do
      errors = ActiveModel::Errors.new(ExampleClass.new)
      errors.add :example, :too_long, :count => 4
      errors.add :example, :invalid
      errors
    end

    it "shuold return a hash for returning to API consumers" do
      expect(hash = errors.to_api_hash).to be_a(Hash)
    end

    it "should have an array of errors for each attribute" do
      expect(errors.to_api_hash[:example]).to be_a(Array)
    end

    it "should have the code, message and options" do
      error = errors.to_api_hash[:example][0]
      expect(error[:code]).to eq(:too_long)
      expect(error[:message]).to match /is too long/
      expect(error[:options]).to be_a Hash
    end
  end

  context "#to_api_hash (with string messages)" do
    subject(:errors) do
      errors = ActiveModel::Errors.new(ExampleClass.new)
      errors.add :example, "is not unique"
      errors
    end

    it "should not have a code or options" do
      error = errors.to_api_hash[:example][0]
      expect(error[:message]).to eq('is not unique')
      expect(error.has_key?(:code)).to be false
      expect(error.has_key?(:options)).to be false
    end
  end

  context "#has_message?" do
    it "should return true if the given error exists on the attribute" do
      errors = ActiveModel::Errors.new(ExampleClass.new)
      errors.add :example, :too_long, :count => 4
      expect(errors.has_message?(:example, :too_long)).to be true
      expect(errors.has_message?(:example, :too_long, :count => 4)).to be true
      expect(errors.has_message?(:example, :too_long, :count => 3)).to be false
    end
  end

  context "#clear" do
    it "should clear API errors" do
      errors = ActiveModel::Errors.new(ExampleClass.new)
      errors.add :example, :blank
      expect(errors.messages).to_not be_empty
      expect(errors.errors_for_api).to_not be_empty
      errors.clear
      expect(errors.messages).to be_empty
      expect(errors.errors_for_api).to be_empty
    end
  end

  context "with presence validator" do
    class PresenceExampleClass < ExampleClass
      validates :example, :presence => true
    end

    it "should have a blank error" do
      p = PresenceExampleClass.new(nil)
      expect(p.valid?).to be false
      expect(p.errors.has_message?(:example, :blank)).to be true
    end
  end

  context "with numericality validator" do
    class NumericalityExampleClass < ExampleClass
      validates :example, :numericality => {:only_integer => true}
    end

    it "should have a not_a_number error" do
      p = NumericalityExampleClass.new("potato")
      expect(p.valid?).to be false
      expect(p.errors.has_message?(:example, :not_a_number)).to be true
    end
  end

  context "with length validator" do
    class LengthExampleClass < ExampleClass
      validates :example, :length => {:minimum => 2, :maximum => 5}
    end

    it "should have a too long error when too long" do
      p = LengthExampleClass.new("morethanfive")
      expect(p.valid?).to be false
      expect(p.errors.has_message?(:example, :too_long)).to be true
      expect(p.errors.has_message?(:example, :too_long, :count => 5)).to be true
    end

    it "should have a too short error when too long" do
      p = LengthExampleClass.new("a")
      expect(p.valid?).to be false
      expect(p.errors.has_message?(:example, :too_short)).to be true
      expect(p.errors.has_message?(:example, :too_short, :count => 2)).to be true
    end
  end

end
