require 'rspec'
require 'pry'
require './attributes'

autoload :IncludeAttrs, File.join(__dir__, "spec", "attributes_helper")

RSpec.shared_examples_for Attributes do
  context 'init with required argument' do
    let(:obj) { described_class.include(IncludeAttrs).new(name: "hello world") }

    it 'should set required attribute' do 
      expect(obj.name).to eq("hello world")
    end

    it 'should throw an error if required attr changed to nil' do 
      expect{ obj.name = nil }.to raise_error(ArgumentError)
    end

    it 'should set default attribute' do 
      expect(obj.state).to eq(:pending)
      expect(obj.count).to eq(0)
    end

    it 'should set default attribute with block' do 
      expect(obj.started_at).to eq(Time.new(2022, 1, 1))
    end

    it 'should create action methods' do 
      obj.incr!
      expect(obj.count).to eq(1)
      obj.decr!
      expect(obj.count).to eq(0)
    end

    it 'should create enum methods' do
      expect(obj.pending?).to eq(true)
      expect(obj.running?).to eq(false)
      expect(obj.stopped?).to eq(false)
      expect(obj.failed?).to eq(false)

      obj.running!
      expect(obj.running?).to eq(true)
      expect(obj.state).to eq(:running)
    end

    it 'should thow an error for incorrect enum' do
      expect{ obj.state = :hello_world }.to raise_error(ArgumentError)
    end
  end

  context 'init without required argument' do 
    let(:obj) { described_class.include(IncludeAttrs).new }

    it 'should throw an error' do
      expect { described_class.new }.to raise_error(ArgumentError)
    end
  end
end

class ExampleClass; end

RSpec.describe ExampleClass do 
  it_should_behave_like Attributes
end
