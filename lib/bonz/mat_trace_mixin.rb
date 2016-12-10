require "bonz/mat_border_mixin"
require "bonz/mat_mask_mixin"
require "bonz/mat_measure_mixin"

module Bonz
  module MatTraceMixin
    extend self

    include MatBorderMixin
    include MatMaskMixin
    include MatMeasureMixin

    def included(mod)
      mod.include(InstanceMethods)
      mod.extend(ClassMethods)
    end

    module InstanceMethods
      def trace_contour(contour)
        closest_line, contiguous = AdvancedToolbox.find_closest_matching_line(self, contour, {})
        unless contiguous
          options = { waypoint_tracing: true }
          closest_line, _ = AdvancedToolbox.find_closest_matching_line(self, contour, options)
        end
        mask_from_points(closest_line)
      end

      # ---------------------------------------------------------------------------
      # Trace a path along :line_mask: using lines from this mask.
      def trace_line_mask(line_mask)
        reduced_line_mask = reduce_along_line_mask(line_mask)
        yield reduced_line_mask if block_given?

        self.class.preserve_edge_contours(reduced_line_mask, line_mask) do |reduced, target|
          method = OpenCV::CV_CHAIN_APPROX_NONE
          target_contours = ContourToolbox.get_contours(target, method: method, include_holes: true)
          target_contours = target_contours.sort { |a, b| b.size <=> a.size }
          target_contours.inject(reduced.blank.to_mask) do |traced, contour|
            traced.or(reduced.trace_contour(contour))
          end
        end
      end

      def mask_along_line_mask(line_mask, radius)
        self.and(line_mask.dilate(nil, radius))
      end

      def reduce_along_line_mask(line_mask)
        outer_radius.to_i.downto(0) do |radius|
          reduced = mask_along_line_mask(line_mask, radius)
          return reduced if reduced.percent_non_zero < 0.1
        end
      end

      def min_preservation_border_width
        [ 0.05 * outer_radius, 10 ].max.to_i
      end
    end

    module ClassMethods
      def preserve_edge_contours(*mats)
        require_same_size(mats)

        width = mats.first.min_preservation_border_width
        bordered = mats.map { |m| m.replicate_border(width) }

        result = yield *bordered
        result.require_same_size(bordered.first)

        result.sub_rect(result.interior_rectangle(width)).copy
      end
    end
  end
end
