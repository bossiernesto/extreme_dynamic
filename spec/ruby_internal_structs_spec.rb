# frozen_string_literal: true
require_relative '../lib/ruby_internal_structs'
require 'spec_helper'
require 'pry'

describe RubyInternalStructs do
  # Spec class
  class A
  end

  let(:a) { A.new }
  let(:expected_class) { anon_object.class }

  describe 'RBasic' do
    shared_examples_for 'is an object type' do
      it 'checks that the inspected struct is an object' do
        expect(flags & RubyConstants::T_MASK).to eq(RubyConstants::T_OBJECT)
      end
    end

    context 'Check basic values' do
      subject(:basic_object) { RubyInternalStructs::RObject.new(a.get_pointer) }

      it 'checks that the klass internal object is the same as the class object address' do
        expect(basic_object.klass).to eq(A.get_object_address)
      end

      context 'checks the object flag' do
        subject(:flags) { RubyInternalStructs::RObject.new(a.get_pointer).flags }

        it 'checks that is not a frozen object' do
          expect(flags & RubyInternalStructs::FL_FREEZE).to be_zero
        end

        it_should_behave_like 'is an object type'
      end
    end

    context 'when the object is frozen' do
      before do
        a.freeze
      end

      context 'check the flags' do
        subject(:flags) { RubyInternalStructs::RObject.new(a.get_pointer).flags }
        let(:freeze_flag) { 1 << 11 }

        it_should_behave_like 'is an object type'

        it 'checks that is a frozen object' do
          expect(flags & RubyInternalStructs::FL_FREEZE).to eq(freeze_flag)
        end
      end
    end
  end

  describe "RClass" do
    context 'Check basic values' do
      subject(:class_struct) { RubyInternalStructs::RClass.new(A.get_pointer) }

      it 'checks that the inspected struct is an object' do
        expect(class_struct.flags & RubyConstants::T_MASK).to eq(RubyConstants::T_CLASS)
      end

      it 'checks that the klass is the singleton class' do
        expect(class_struct.klass).to eq(A.singleton_class.get_object_address)
      end
    end
  end
end
