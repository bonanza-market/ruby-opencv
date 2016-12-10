require "bonz/ruby"

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

      def outer_radius
        0.5 * diagonal_length
      end

      def same_size?(*mats)
        self.class.same_size?(Ruby.from_varargs_or_array(*mats).unshift(self))
      end

      def require_same_size(*mats)
        self.class.require_same_size(Ruby.from_varargs_or_array(*mats).unshift(self))
      end

      def info
        { size: size.to_s, depth: depth, channel: channel, avg: avg.to_s, sdv: sdv.to_s }
      end
    end

    module ClassMethods
      def same_size?(*mats)
        unique_count = Ruby.from_varargs_or_array(*mats).map(&:size).map(&:to_a).uniq.count
        [ 0, 1 ].include?(unique_count) # all elements of empty set are equal
      end

      def require_same_size(*mats)
        unless same_size?(*mats)
          mats = Ruby.from_varargs_or_array(*mats)
          message = "mats not same size: #{ mats.map(&:size).map(&:to_s) }"
          raise OpenCV::CvStsUnmatchedSizes.new(message)
        end
      end
    end
  end
end
