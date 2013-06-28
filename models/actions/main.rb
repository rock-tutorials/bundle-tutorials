# The main planner. A planner of this model is automatically added in the
# Interface planner list.
require 'models/profiles/rocks'
class Main < Roby::Actions::Interface
    use_profile Tutorials::Rocks
end

