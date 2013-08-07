require 'models/actions/main'
require 'models/profiles/rocks'
require 'models/actions/fence'
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

    # This has been defined for the fenced_random_move action above. We simply
    # add a new event to it and reuse it for the
    # fenced_random_move_with_monitors action
    FencedRandomMove.event :crossed_fence

    describe('random motion within a delimited area').
        returns(FencedRandomMove).
        optional_arg('fence_size', 'size in meters of the fence around the origin', 3).
        optional_arg('threshold', 'size in meters we need to be from the origin to consider that we have reached it', 1)
    action_state_machine 'fenced_random_move_with_monitors' do
        # The 'move randomly' state
        random = state random_def
        # Monitor that verifies that we don't go outside the fence. Emit the
        # cross_fenced event on the state machine's task when it happens
        #
        # The rest of the options passes arguments from the action state machine
        # to the monitor
        random.monitor('fence', random.rock_child.pose_samples_port, :fence_size => fence_size).
            trigger_on do |pose|
                puts "#{pose.position.x} #{pose.position.y}"
                pose.position.x.abs > fence_size || pose.position.y.abs > fence_size
            end.
            emit crossed_fence_event

        # The move-to-origin state
        origin = state to_origin_def.use(rock1_dev).use_deployments(/target/)
        # Monitor that waits for us to be close enough to the center
        origin.monitor('reached_center', origin.rock_child.pose_samples_port, :threshold => threshold).
            trigger_on do |pose|
                puts "#{pose.position.x} #{pose.position.y}"
                pose.position.x.abs < threshold && pose.position.y.abs < threshold
            end.
            emit origin.success_event

        # We start by moving randomly
        start random
        # We transition each time the rock passes the fence
        transition random, crossed_fence_event, origin
        # And transition back when we reach the origin
        transition origin, origin.success_event, random
    end

    describe('random motion within a delimited area').
        optional_arg('fence_size', 'size in meters of the fence around the origin', 1).
        optional_arg('threshold', 'size in meters we need to be from the origin to consider that we have reached it', 1)
    action_state_machine 'fenced_random_move_with_fault_response_table' do
        use_fault_response_table Tutorials::Fence,
            :origin_reached_threshold => threshold,
            :fence_size => fence_size

        # And move randomly ... "forever"
        random = state random_def
        start random
    end
end

