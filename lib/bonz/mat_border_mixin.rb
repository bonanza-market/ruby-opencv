module Bonz
  module MatBorderMixin
    extend self

    def included(mod)
      mod.include(InstanceMethods)
      mod.extend(ClassMethods)
    end

    module InstanceMethods
      # Calculate mat size with an added border of :border_width:.
      def bordered_size(border_width)
        OpenCV::CvSize.new(columns + 2 * border_width, rows + 2 * border_width)
      end

      # Find the interior rectangle assuming a border of :border_width:.
      def interior_rectangle(border_width)
        interior_width = columns - 2 * border_width
        interior_height = rows - 2 * border_width
        OpenCV::CvRect.new(border_width, border_width, interior_width, interior_height)
      end

      # Add a replicated border of :border_width:.
      def replicate_border(border_width)
        offset = OpenCV::CvPoint.new(border_width, border_width)
        copy_make_border(:replicate, bordered_size(border_width), offset)
      end
    end

    module ClassMethods
    end
  end
end
