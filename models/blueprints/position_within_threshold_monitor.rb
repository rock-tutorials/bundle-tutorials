require 'rock/models/blueprints/pose'
module Tutorials
  # Composition that checks whether a position is within a certain threshold
  # from a target
  class PositionWithinThresholdMonitor < Syskit::Composition
    # The target pose, as Types::Base::Position
    argument :target
    # The target threshold
    argument :threshold, :default => 1
    # Emitted when the tracked pose is within threshold of the target
    event :reached

    # The position provider we are monitoring
    add Base::PositionSrv, :as => 'position'

    # Tests if the given position is within threshold of the target
    #
    # @param [Types::Base::Position] the position
    # @return [Boolean]
    def in_threshold?(p)
      (p - target).norm < threshold
    end

    # A script context. This allows us to have a proper access to ports in
    # children. A raw Roby poll block would be possible, but would require that
    # we know the type of the final position component.
    script do
      # Get a data reader on the position provider
      position_r = position_child.position_samples_port.reader
      # The block given to #poll is executed once per Roby execution cycle
      # (usually once per 100ms)
      poll do
        # Emit if we have a position and it is within threshold
        if (p = position_r.read_new) && in_threshold?(p.position)
          reached_event.emit
        end
      end
    end
  end
end
