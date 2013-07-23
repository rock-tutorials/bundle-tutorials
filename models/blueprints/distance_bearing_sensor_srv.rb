import_types_from 'tut_sensor'
module Tutorials
    data_service_type 'DistanceBearingSensorSrv' do
        output_port 'samples', '/rock_tutorial/BearingDistanceSensor'
    end
end
