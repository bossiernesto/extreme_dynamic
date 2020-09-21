require 'fiddle'
require 'internalobject/internalobject'


class Object
  # RUBY_FL_FREEZE = (1<<11) http://git.io/v8WEt

  # [         0          ][        1        ]
  #  0 1 2 3  4  5  6   7    8   9   10   11 ...
  #  1 2 4 8 16 32 64 128  256 512 1024 2048 ...
  #                          1   2    4    8 < Zero this bit unconditionally.
  def unfreeze
    object_id = ObjectInternals.internal_object_id(self)
    Fiddle::Pointer.new(object_id << 1)[1] &= ~8
    self
  end
end

str = 'foo'.freeze
p str.frozen?
str << 'bar' rescue p $!

