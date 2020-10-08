require_relative '../lib/ruby_internal'
describe RubyInternal do

  context 'get_object_address' do
    let(:object) { Object.new }
    let(:expected_hex_object_id_value) { /:0x(.+)>$/.match(Kernel.instance_method(:to_s).bind_call(object))[1].to_i(16) }

    before do
      object.class.class_eval do
        include RubyInternal
      end
    end

    it 'should match the id on the to_s with the one for the internal' do
      expect(object.get_object_address.to_s).to eq(expected_hex_object_id_value.to_s)
    end

    context 'when we threat primitive values' do
      before do
        class Object
          include RubyInternal
        end
      end

      it 'False should yield ' do
        expect(false.get_object_address).to eq(RubyConstants::RUBY_Qfalse)
      end

      it 'True should yield ' do
        expect(true.get_object_address).to eq(RubyConstants::RUBY_Qtrue)
      end

      it 'Nil should yield ' do
        expect(nil.get_object_address).to eq(RubyConstants::RUBY_Qnil)
      end

      #define INT2FIX(i) ((VALUE)(((long)(i))<<1 | FIXNUM_FLAG))
      context 'with ' do
        let(:test_numbers) { [0,1,2,3].map { |x| [x, x.int_2_fix]} }

          it "returns the internal when " do
            test_numbers.each do |val, expected|
              expect(val.get_object_address).to eq(expected)
            end
          end
      end
    end
  end
end