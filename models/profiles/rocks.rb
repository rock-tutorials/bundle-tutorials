require 'models/blueprints/rock_control'
using_task_library 'controldev'
using_task_library 'tut_brownian'
using_task_library 'tut_follower'

module Tutorials
  profile 'Rocks' do
      define 'joystick',    Tutorials::RockControl.
          use(Controldev::JoystickTask).
          use_deployments(/target/)
      define 'random',      Tutorials::RockControl.
          use(TutBrownian::Task).
          use_deployments(/target/)
      define 'random_slow', Tutorials::RockControl.
          use(TutBrownian::Task.with_conf('default', 'slow')).
          use_deployments(/target/)
      define 'random_slow2', Tutorials::RockControl.
          use(TutBrownian::Task).with_conf('slow').
          use_deployments(/target/)
      define 'leader', Tutorials::RockControl.
          use(TutBrownian::Task).
          use_deployments(/target/)
      define 'follower', Tutorials::RockControl.
          use(TutFollower::Task, leader_def).
          use_deployments(/follower/)
  end
end
