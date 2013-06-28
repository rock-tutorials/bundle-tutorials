import_types_from 'base'
module Tutorials
    data_service_type 'CommandGeneratorSrv' do
        output_port 'cmd', '/base/MotionCommand2D'
    end
end
