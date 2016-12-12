require "bonz/mat_measure_mixin"
require "bonz/mat_border_mixin"
require "bonz/mat_mask_mixin"
require "bonz/mat_general_mixin"

module OpenCV
  class CvMat
    include Bonz::MatMeasureMixin
    include Bonz::MatBorderMixin
    include Bonz::MatMaskMixin
    include Bonz::MatGeneralMixin
  end
end
