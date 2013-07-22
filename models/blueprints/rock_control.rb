require 'rock/models/blueprints/pose'
require 'rock/models/blueprints/control'
using_task_library 'rock_tutorial'
using_task_library 'tut_follower'
using_task_library 'tut_sensor'
module Tutorials
    class RockControl < Syskit::Composition
        add Base::Motion2DControllerSrv, :as => "cmd"
        add RockTutorial::RockTutorialControl, :as => "rock"
        cmd_child.connect_to rock_child

        conf 'slow',
            cmd_child => ['default', 'slow']

        export rock_child.pose_samples_port
        provides Base::PoseSrv, :as => 'pose'

        specialize cmd_child => TutFollower::Task do
            add Base::PoseSrv, :as => "target_pose"
            add TutSensor::Task, :as => 'sensor'

            target_pose_child.connect_to sensor_child.target_frame_port
            rock_child.connect_to sensor_child.local_frame_port
            sensor_child.connect_to cmd_child
        end
    end
end
