require 'models/blueprints/devices'
class RockTutorial::RockTutorialControl
  driver_for Dev::Platforms::Rock, :as => 'driver'
  transformer do
    # Note: the local names have to match the names of the properties used to
    # configure the source/target frames in the orogen file (body_frame and
    # world_frame)
    transform_output 'pose_samples', 'body' => 'world'
    associate_frame_to_ports 'body', 'motion_command'
  end
end

