require 'models/actions/main'
require 'models/profiles/rocks'
class Main < Roby::Actions::Interface
    use_profile Tutorials::RocksWithTransformer

    describe('move randomly as long as in a 10 meter square around origin, move back
to origin when passing the border')
    action_state_machine 'fenced_random_move' do
        # We need to call #state to transform an action / definition into a proper
        # state
        random = state random_def
        # 'task' is used for tasks that are not used as states
        fence_monitor = task Tutorials::FenceMonitor.use(rock1_dev)
        # We need this monitor only in the random state
        random.depends_on fence_monitor

        origin = state to_origin_def.use(rock1_dev)
        # 'task' is used for tasks that are not used as states
        target_monitor = task Tutorials::PositionWithinThresholdMonitor.
            use(rock1_dev).with_arguments('target' => Types::Base::Position.new(0, 0, 0))
        # We need this monitor only in the origin state
        origin.depends_on target_monitor

        # We start by moving randomly
        start random
        # We transition each time the rock passes the fence
        transition random, fence_monitor.passed_fence_outwards_event, origin
        # And transition back when we reach the origin
        transition origin, target_monitor.reached_event, random
    end
end

