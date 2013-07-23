require 'rock/models/blueprints/control'
class TutFollower::Task
    provides Base::Motion2DControllerSrv, :as => 'cmd'
    transformer do
        associate_frame_to_ports 'ref', 'bearing_distance', 'cmd'
    end
end

