require 'internalobject/internalobject'

module InternalHelpers
  def expected_sym_to_id(sym)
    raise TypeError unless sym.is_a? Symbol

    (ObjectInternals.symbol_to_id(sym) * RubyConstants::RVALUE_size + (4 << 2)) | 28
  end
end