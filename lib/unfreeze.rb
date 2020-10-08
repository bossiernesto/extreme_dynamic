require 'fiddle'
require_relative 'ruby_internal'

class Object
  include RubyInternal
  # RUBY_FL_FREEZE = (1<<11) http://git.io/v8WEt

  # [         0          ][        1        ]
  #  0 1 2 3  4  5  6   7    8   9   10   11 ...
  #  1 2 4 8 16 32 64 128  256 512 1024 2048 ...
  #                          1   2    4    8 < Zero this bit unconditionally.
  def unfreeze
    get_pointer[1] &= ~8
    self
  end
end
