module Bonz
  module MatGeneralMixin
    extend self

    def included(mod)
      mod.include(InstanceMethods)
      mod.extend(ClassMethods)
    end

    module InstanceMethods
      # @see fill
      def fill_points(value, points)
        copy.fill_points!(value, points)
      end

      # @see fill!
      def fill_points!(value, points)
        points.each { |p| self[p.y, p.x] = value }
        self
      end

      # Convert to single channel. If already single channel, return :self:.
      # Assumes any 3- or 4-channel image is BGR(A) (not HSV).
      def to_gray
        case channel
        when 1 then self
        when 3 then self.BGR2GRAY
        when 4 then self.BGRA2GRAY
        else split.first
        end
      end
    end

    # Convert to BGR. If already BGR, return :self:. Assumes any 3- or
    # 4-channel image is already BGR(A) (not HSV).
    def to_bgr
      case channel
      when 1 then self.GRAY2BGR
      when 3 then self
      when 4 then self.BGRA2BGR
      else
        # ambiguous what the caller actually wants here
        raise ArgumentError.new("ambiguous conversion of #{ channel } channels to BGR")
      end
    end

    module ClassMethods
      def new_sized(size)
        new(size.height, size.width)
      end
    end
  end
end
