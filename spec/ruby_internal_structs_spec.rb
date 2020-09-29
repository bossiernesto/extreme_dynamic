require_relative '../lib/ruby_internal_structs'

describe RubyInternalStructs do

  context 'RubyObjHeap' do
    let(:anon_object) { Object.new }
    let(:expected_class) { anon_object.class }

    it '' do
      anon_object.get_object_address
    end

  end
end