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
        expect(false.get_object_address).to eq(0)
      end

      it 'True should yield ' do
        expect(true.get_object_address).to eq(40)
      end

      it 'Nil should yield ' do
        expect(nil.get_object_address).to eq(16)
      end

      #
      # #define INT2FIX(i) ((VALUE)(((long)(i))<<1 | FIXNUM_FLAG))
      #  122  #define FIXNUM_FLAG 0x01
      expected_values = [[0,2], [1, 6], [2, 10], [3, 14]]
      expected_values.each do |val, expected|
        it "returns #{expected} when number is #{val}" do
          expect(val.get_object_address).to eq(expected)
        end
      end
    end
  end

end