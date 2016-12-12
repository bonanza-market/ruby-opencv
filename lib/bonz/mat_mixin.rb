require "bonz/mat_measure_mixin"
require "bonz/mat_border_mixin"
require "bonz/mat_mask_mixin"
require "bonz/mat_general_mixin"

module Bonz
  module MatMixin
    extend self

    def included(mod)
      mixins = [ MatMeasureMixin, MatBorderMixin, MatMaskMixin, MatGeneralMixin ]
      mixins.each do |m|
        mod.include(m::InstanceMethods)
        mod.extend(m::ClassMethods)
      end
    end
  end
end
