require 'rock/models/blueprints/pose'

module Tutorials
  class PositionWithinThresholdMonitor < Syskit::Composition
    terminates

    # The target pose
    argument :target
    # The target threshold
    argument :threshold, :default => 1
    # Emitted when the tracked pose passes the required fence towards the
    # outside.
    event :reached

    add Base::PositionSrv, :as => 'position'

    # Tests if the given position is within the fence
    def in_threshold?(p)
      (p - target).norm < threshold
    end

    # A script context. This allows us to have a proper access to ports in
    # children. A raw Roby poll block would be possible, but would require that
    # we know the type of the final position component.
    script do
      position_r = position_child.position_samples_port.reader
      poll do
        if (p = position_r.read) && in_threshold?(p.position)
          reached_event.emit
        end
      end
    end
  end
end
