require 'rock/models/blueprints/pose'
module Tutorials
  # Given a position provider, checks whether this position crosses a specified
  # boundary around the origin
  class FenceMonitor < Syskit::Composition
    # The size of the allowed square
    argument :fence_size, :default => 10
    # Emitted when the tracked pose passes the required fence towards the
    # outside
    event :passed_fence_outwards

    # The position provider that we will be monitoring
    add Base::PositionSrv, :as => 'position'

    # Tests if the given position is within the fence
    #
    # @param [Types::Base::Position] the position
    # @return [Boolean]
    def in_fence?(p)
      p.x.abs < fence_size && p.y.abs < fence_size
    end

    # This script context allows us to have a proper access to ports in
    # children. A raw Roby poll block would be possible, but would require that
    # we know the type of the final position component.
    script do
      # Get a reader object that allows us to read the position
      position_r = position_child.position_samples_port.reader
      # The block given to #poll is executed once per Roby execution cycle
      # (usually once per 100ms)
      poll do
        # If we have a position
        if p = position_r.read_new
          # p is a RigidBodyState, we only need the position part of it
          p = p.position
          # Initialize @last_p if it is not initialized yet
          @last_p ||= p
          # If we cross the border, emit the event
          if in_fence?(@last_p) && !in_fence?(p)
            passed_fence_outwards_event.emit
          end
          @last_p = p
        end
      end
    end
  end
end
