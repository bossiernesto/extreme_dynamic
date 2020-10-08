require_relative '../lib/unfreeze'
require 'spec_helper'

describe 'unfreeze' do
  let(:frozen_instance) { Object.new.freeze }

  it 'should be frozen and unable to be modified' do
    expect { frozen_instance.instance_variable_set(:@an_attr, 1) }.to raise_error(FrozenError)
  end

  context 'when unfreeze is used' do
    subject { frozen_instance.unfreeze }

    it 'should not raise a frozen error now' do
      expect { subject.instance_variable_set(:@an_attr, 1) }.not_to raise_error
    end

    it 'should be able to modify the state of the object again' do
      subject.instance_variable_set(:@an_attr, 1)
      expect(frozen_instance.instance_variable_get(:@an_attr)).to eq(1)
    end
  end
end