module Bonz
  module Ruby
    extend self

    def from_varargs_or_array(*values)
      passed_array = values.first.is_a?(Array) && values.count == 1
      passed_array ? values.first : values
    end
  end
end
