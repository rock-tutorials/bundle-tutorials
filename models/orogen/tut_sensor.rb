require 'models/blueprints/distance_bearing_sensor_srv'
class TutSensor::Task
    provides Tutorials::DistanceBearingSensorSrv, :as => 'sensor'
end
class TutSensor::TransformerTask
    provides Tutorials::DistanceBearingSensorSrv, :as => 'sensor'
end
