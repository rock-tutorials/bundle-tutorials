require 'models/blueprints/rock_control'
using_task_library 'controldev'
using_task_library 'tut_brownian'
using_task_library 'tut_follower'

module Tutorials
    profile 'Rocks' do
        robot do
            device Dev::Controldev::Joystick, :as => 'joystick'
            device(Dev::Platforms::Rock, :as => 'rock1').
                use_deployments(/target/)
            device(Dev::Platforms::Rock, :as => 'rock2').
                use_deployments(/follower/)
        end

        define 'joystick',    Tutorials::RockControl.
            use(joystick_dev, rock1_dev)
        define 'random',      Tutorials::RockControl.
            use(TutBrownian::Task, rock1_dev)
        define 'random2',      Tutorials::RockControl.
            use(TutBrownian::Task, rock2_dev)
        define 'random_slow', Tutorials::RockControl.
            use(TutBrownian::Task.with_conf('default', 'slow'), rock1_dev)
        define 'random_slow2', Tutorials::RockControl.
            use(TutBrownian::Task, rock1_dev).with_conf('slow')
        define 'leader', Tutorials::RockControl.
            use(TutBrownian::Task, rock1_dev)
        define 'follower', Tutorials::RockControl.
            use(TutFollower::Task, rock2_dev, 'target_pose' => leader_def)
    end
end
