require "bonz/mat_general_mixin"

module Bonz
  module MatMaskMixin
    extend self

    include MatGeneralMixin

    def included(mod)
      mod.include(InstanceMethods)
      mod.extend(ClassMethods)
    end

    module InstanceMethods
      def white
        fill(OpenCV::CvColor::White)
      end

      def to_mask
        threshold(0, 255, OpenCV::CV_THRESH_BINARY).to_gray
      end

      def binary_invert
        threshold(0, 255, OpenCV::CV_THRESH_BINARY_INV).to_gray
      end

      def mask_from_points(points)
        zero.to_mask.fill_points!(OpenCV::CvColor::White, points)
      end
    end

    module ClassMethods
    end
  end
end
