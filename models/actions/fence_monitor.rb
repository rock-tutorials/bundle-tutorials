module Tutorials
    # Define a list of data monitors
    class FenceMonitors < Syskit::Coordination::DataMonitoringTable
        # This table can be applied only on tasks of this type
        root Base::PositionSrv
        # It requires one argument
        argument :fence_size, :default => 5

        # This is almost a copy/paste of the previous monitor. The
        # differences are that arguments do not need to be provided
        # anymore (they are listed at the table level) and we
        # raise_exception instead of emit. The port is also
        # referred to directly as we attach to the PositionSrv directly
        monitor('fence_crossed', position_samples_port).
            trigger_on do |pose|
                pose.position.x.abs > fence_size ||
                    pose.position.y.abs > fence_size
            end.
            raise_exception # We want this monitor to generate a fault
    end
end
