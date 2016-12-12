module Bonz
  module MatGeneralMixin
    extend self

    def included(mod)
      mod.include(InstanceMethods)
      mod.extend(ClassMethods)
    end

    module InstanceMethods
      # @see set
      # @see fill
      def set_points(value, points)
        copy.set_points!(value, points)
      end
      alias_method :fill_points, :set_points

      # @see set!
      # @see fill!
      def set_points!(value, points)
        points.each { |p| self[p.y, p.x] = value }
        self
      end
      alias_method :fill_points!, :set_points!

      # Convert to single channel. If already single channel, return :self:.
      def to_gray
        case channel
        when 1 then self
        when 3 then BGR2GRAY
        when 4 then BGRA2GRAY
        else split.first
        end
      end
    end

    module ClassMethods
      def new_sized(size)
        new(size.height, size.width)
      end
    end
  end
end
