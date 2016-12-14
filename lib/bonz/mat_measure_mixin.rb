module Bonz
  module MatMeasureMixin
    extend self

    def included(mod)
      mod.include(InstanceMethods)
      mod.extend(ClassMethods)
    end

    module InstanceMethods
      def area
        rows * columns
      end

      def percent_non_zero
        count_non_zero / area.to_f
      end

      def diagonal_length
        Math.sqrt(rows ** 2 + columns ** 2)
      end

      # Radius of the circumscribed circle.
      def outer_radius
        0.5 * diagonal_length
      end

      def same_size?(*mats)
        self.class.same_size?(Array.wrap(*mats).unshift(self))
      end

      # Raise :OpenCV::CvStsUnmatchedSizes: if :mats: are not the same size.
      def require_same_size(*mats)
        self.class.require_same_size(Array.wrap(*mats).unshift(self))
      end

      # Hash of image properties. This method is intended for debugging.
      def info
        { size: size.to_s, depth: depth, channel: channel, avg: avg.to_s, sdv: sdv.to_s }
      end
    end

    module ClassMethods
      # Note that all mats in the empty or a singleton set are considered to be
      # the same size since :true: is the identity element:
      #
      #   same_size?(A, B, C) <=> true && A.size == B.size && B.size == C.size
      #   same_size?(A, B)    <=> true && A.size == B.size
      #   same_size?(A)       <=> true
      #   same_size?          <=> true
      #
      def same_size?(*mats)
        unique_count = Array.wrap(*mats).map(&:size).map(&:to_a).uniq.count
        [ 0, 1 ].include?(unique_count)
      end

      # @see :InstanceMethods#require_same_size:
      def require_same_size(*mats)
        unless same_size?(*mats)
          mats = Array.wrap(*mats)
          message = "mats not same size: #{ mats.map(&:size).map(&:to_s) }"
          raise OpenCV::CvStsUnmatchedSizes.new(message)
        end
      end
    end
  end
end
