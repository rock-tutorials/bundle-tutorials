require 'models/blueprints/rock_control'
using_task_library 'controldev'
using_task_library 'tut_brownian'
using_task_library 'tut_follower'

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
      Tutorials::RockControl.use(TutFollower::Task, leader_def).
        use_deployments(/follower/)
  end
end
