module Bonz
  module Ruby
    extend self
    
    # Convert varargs or a single array to an array. Allows a method to
    # accept either form.
    #
    # Does NOT work with a variable number of array arguments.
    def from_varargs_or_array(*values)
      passed_array = values.first.is_a?(Array) && values.count == 1
      passed_array ? values.first : values
    end
  end
end
