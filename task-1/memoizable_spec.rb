require 'rspec'
require_relative './memoizable'
require_relative './example'

RSpec.shared_examples_for Memoizable do
  before(:each) do
    @obj = described_class.new
    @method = described_class.define_method(:hello_world) do 
      rand
    end
  end

  context 'without memoization' do
    it 'it should return different value' do
      expect(@obj.send(@method)).not_to eq(@obj.send(@method))
    end
  end

  context 'with memoization' do
    it 'it should return memoized value' do
      described_class.memoize(@method)
      expect(@obj.send(@method)).to eq(@obj.send(@method))
    end
  end

  context 'with correct :as option' do
    it 'memoize the value into :as variable' do
      name = :@cached_method
      described_class.memoize(@method, { as: name })

      expect(@obj.send(@method)).to eq(@obj.send(@method))
      expect(@obj.instance_variable_get(name)).to eq(@obj.send(@method))
    end
  end

  context 'with incorrect :as option' do
    it 'should throw an error if as: param is incorrect' do
      expect { described_class.memoize(method, as: :wrong_var_name) }.to raise_error(ArgumentError)
    end
  end
end

RSpec.describe Example do 
  it_should_behave_like Memoizable do
    let(:method_with_as_option) { :bar }
    let(:options) {{ as: :@bar_cached }}
  end
end
