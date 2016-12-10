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
      def blank
        fill(OpenCV::CvColor::Black)
      end

      def full
        fill(OpenCV::CvColor::White)
      end

      def to_mask
        threshold(0, 255, OpenCV::CV_THRESH_BINARY).to_gray
      end

      def binary_invert
        threshold(0, 255, OpenCV::CV_THRESH_BINARY_INV).to_gray
      end

      def mask_from_points(points)
        blank.to_mask.set_points!(OpenCV::CvColor::White, points)
      end
    end

    module ClassMethods
      def mask_from_points(size, points)
        new_sized(size).mask_from_points(points)
      end
    end
  end
end
