class RockTutorial::RockTutorialControl
    transformer do
        frames 'world', 'body'
        transform_output 'pose_samples', 'body' => 'world'
    end
end
