require 'rock/models/blueprints/pose'

module Tutorials
  class FenceMonitor < Syskit::Composition
    terminates

    # The size of the allowed square
    argument :fence_size, :default => 3
    # Emitted when the tracked pose passes the required fence towards the
    # outside
    event :passed_fence_outwards

    add Base::PositionSrv, :as => 'position'

    # Tests if the given position is within the fence
    def in_fence?(p)
      p.x.abs < fence_size && p.y.abs < fence_size
    end

    # This script context allows us to have a proper access to ports in
    # children. A raw Roby poll block would be possible, but would require that
    # we know the type of the final position component.
    script do
      position_r = position_child.position_samples_port.reader
      poll do
        if p = position_r.read
          p = p.position
          if !@last_p
            @last_p = p
          end
          if in_fence?(@last_p) && !in_fence?(p)
            puts "passed !"
            passed_fence_outwards_event.emit
          else puts "not passed ! #{p.x} #{p.y} #{fence_size}"
          end
          @last_p = p
        end
      end
    end
  end
end
