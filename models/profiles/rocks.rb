require 'models/blueprints/rock_control'
using_task_library 'controldev'
using_task_library 'tut_brownian'
using_task_library 'tut_follower'

module Tutorials
    profile 'BaseRocks' do
        robot do
            device Dev::Controldev::Joystick, :as => 'joystick'
            device Dev::Platforms::Rock, :as => 'rock1'
            device Dev::Platforms::Rock, :as => 'rock2'
        end

        define 'joystick',    Tutorials::RockControl.
            use(joystick_dev, rock1_dev).
            use_deployments(/target/)
        define 'random',      Tutorials::RockControl.
            use(TutBrownian::Task, rock1_dev).
            use_deployments(/target/)
        define 'random2',      Tutorials::RockControl.
            use(TutBrownian::Task, rock2_dev).
            use_deployments(/follower/)
        define 'random_slow', Tutorials::RockControl.
            use(TutBrownian::Task.with_conf('default', 'slow'), rock1_dev).
            use_deployments(/target/)
        define 'random_slow2', Tutorials::RockControl.
            use(TutBrownian::Task, rock1_dev).with_conf('slow').
            use_deployments(/target/)
        define 'leader', Tutorials::RockControl.
            use(TutBrownian::Task, rock1_dev).
            use_deployments(/target/)
        define 'follower', Tutorials::RockFollower.
            use(TutFollower::Task, rock2_dev).
            use_deployments(/follower/)
    end
    profile 'RocksWithoutTransformer' do
        use_profile BaseRocks
        define 'follower', follower_def.use(TutSensor::Task, 'target_pose' => leader_def)
    end
    profile 'RocksWithTransformer' do
        use_profile BaseRocks
        define 'follower', follower_def.use(TutSensor::TransformerTask)
    end
end
