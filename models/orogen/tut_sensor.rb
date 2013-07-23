require 'models/blueprints/distance_bearing_sensor_srv'
TutSensor::Task.provides Tutorials::DistanceBearingSensorSrv,
      :as => 'sensor'
TutSensor::TransformerTask.provides Tutorials::DistanceBearingSensorSrv,
        :as => 'sensor'
