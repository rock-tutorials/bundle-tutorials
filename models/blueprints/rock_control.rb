require 'rock/models/blueprints/pose'
require 'models/blueprints/command_generator_srv'
require 'models/blueprints/distance_bearing_sensor_srv'
using_task_library 'rock_tutorial'
using_task_library 'tut_follower'
using_task_library 'tut_sensor'
module Tutorials
    class RockControl < Syskit::Composition
        add CommandGeneratorSrv, :as => "cmd"
        add RockTutorial::RockTutorialControl, :as => "rock"
        cmd_child.connect_to rock_child

        conf 'slow',
            cmd_child => ['default', 'slow']

        export rock_child.pose_samples_port
        provides Base::PoseSrv, :as => 'pose'
    end

    class RockFollowing < RockControl
        overload 'cmd', TutFollower::Task
        add DistanceBearingSensorSrv, :as => 'sensor'
        sensor_child.connect_to cmd_child

        specialize sensor_child => TutSensor::Task do
            add Base::PoseSrv, :as => "target_pose"

            target_pose_child.connect_to sensor_child.target_frame_port
            rock_child.connect_to sensor_child.local_frame_port
        end
    end
end
