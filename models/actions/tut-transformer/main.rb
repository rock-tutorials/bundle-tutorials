require 'models/actions/main'
require 'models/profiles/rocks'
class Main < Roby::Actions::Interface
    use_profile Tutorials::RocksWithTransformer
end

