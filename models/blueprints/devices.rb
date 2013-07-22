# Load the device file from the Rock bundle
require 'rock/models/blueprints/devices'
# Required for PoseSrv. Remember, this is
# given to you in syskit browse
require 'rock/models/blueprints/pose'
# Define the Rock device type. The 'platform' namespace is
# used to define whole platforms (e.g. the name of a commercial
# robot)
Dev::Platforms.device_type 'Rock' do
  # All Rock device drivers provide the Rock pose
  provides Base::PoseSrv
end
