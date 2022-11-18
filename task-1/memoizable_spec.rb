require 'rspec'
require_relative './memoizable'
require_relative './example'

RSpec.shared_examples_for Memoizable do
  let(:obj) { described_class.new }

  before(:each) do
    @method = described_class.define_method(:hello_world) { rand }
    @args_method = described_class.define_method(:summary) { |*args| args.inject(:+) }
  end

  context 'without memoization' do
    it 'should return different value' do
      expect(obj.send(@method)).not_to eq(obj.send(@method))
    end
  end

  context 'with memoization' do
    it 'should return memoized value' do
      described_class.memoize(@method)
      expect(obj.send(@method)).to eq(obj.send(@method))
    end
  end

  context 'with correct :as option' do
    it 'should memoize the value into :as variable' do
      name = :@cached_method
      described_class.memoize(@method, { as: name })

      expect(obj.send(@method)).to eq(obj.send(@method))
      expect(obj.instance_variable_get(name)).to eq(obj.send(@method))
    end
  end

  context 'with incorrect :as option' do
    it 'should throw an error if as: param is incorrect' do
      expect { described_class.memoize(method, as: :wrong_var_name) }.to raise_error(ArgumentError)
    end
  end

  context 'with args' do
    it 'should memoize args result' do
      args = [1, 2]

      obj.send(@args_method, *args)
      expect(obj.instance_variable_get(:@summary_cached)).to eq nil

      described_class.memoize(@args_method)
      obj.send(@args_method, *args)
      expect(obj.instance_variable_get(:@summary_cached)[args.hash]).to eq 3
    end
  end
end

RSpec.describe Example do 
  it_should_behave_like Memoizable
end
