module Tutorials
    class FencedRandomMove < Roby::Task
        terminates
        event :crossed_fence
    end
end
