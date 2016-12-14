require "bonz/mat_measure_mixin"
require "bonz/mat_mask_mixin"
require "bonz/mat_general_mixin"

module OpenCV
  # Add custom Bonanza methods to OpenCV::CvMat.
  class CvMat
    include Bonz::MatMeasureMixin
    include Bonz::MatMaskMixin
    include Bonz::MatGeneralMixin
  end
end
