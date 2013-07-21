require 'models/blueprints/rock_control'
using_task_library 'controldev'
using_task_library 'tut_brownian'
using_task_library 'tut_follower'
using_task_library 'tut_sensor'

module Tutorials
  profile 'Rocks' do
    define 'joystick',    Tutorials::RockControl.use(Controldev::JoystickTask)
    define 'random',      Tutorials::RockControl.use(TutBrownian::Task)
    define 'random_slow', Tutorials::RockControl.use(TutBrownian::Task.with_conf('default', 'slow'))
    define 'random_slow2', Tutorials::RockControl.use(TutBrownian::Task).with_conf('slow')
    define 'leader',
      Tutorials::RockControl.use(TutBrownian::Task).
        use_deployments(/target/)
    define 'follower',
      Tutorials::RockFollowing.use(TutFollower::Task, leader_def).
        use_deployments(/follower/)
  end
  profile 'Plain' do
    use_profile Rocks
    use Tutorials::DistanceBearingSensorSrv => TutSensor::Task
  end

  profile 'Transformer' do
    use_profile Rocks

    leader_def.use_frames('world' => 'world', 'body' => 'leader')
    follower_def.use_frames('world' => 'world', 'body' => 'follower')
    binding.pry

    use Tutorials::DistanceBearingSensorSrv => TutSensor::TransformerTask.
        use_frames('ref' => 'follower', 'target' => 'leader', 'world' => 'world')
    transformer do
        frames 'leader', 'follower', 'world'
        dynamic_transform leader_def, 'leader' => 'world'
        dynamic_transform follower_def, 'follower' => 'world'
    end
  end
end
