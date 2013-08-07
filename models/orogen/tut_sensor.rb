require 'models/blueprints/distance_bearing_sensor_srv'
TutSensor::Task.provides Tutorials::DistanceBearingSensorSrv,
      :as => 'sensor'
TutSensor::TransformerTask.provides Tutorials::DistanceBearingSensorSrv,
        :as => 'sensor'
class TutSensor::TransformerTask
    transformer do
        associate_frame_to_ports 'ref', 'target_sensor_sample'
    end
end
