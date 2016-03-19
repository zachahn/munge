require "fileutils"
require "forwardable"
require "pathname"
require "set"
require "yaml"

require "tilt"

if File.exist?(File.expand_path("../../.git", __FILE__))
  require "pry-byebug"
end

# Core
require "munge/version"
require "munge/item"
require "munge/util/path"
require "munge/util/symbol_hash"
require "munge/util/config"
require "munge/system/router"
require "munge/system/item_factory"
require "munge/system/collection"
require "munge/system/readers/filesystem"
require "munge/system/write"
require "munge/system/alterant"
require "munge/system"
require "munge/write_manager"
require "munge/application"
require "munge/runner"
require "munge/bootstrap"

# Extensions
require "munge/helpers/asset_tags"
require "munge/helpers/asset_paths"
require "munge/helpers/capture"
require "munge/helpers/find"
require "munge/helpers/link"
require "munge/helpers/rendering"
require "munge/helpers/tag"
require "munge/routers/auto_add_extension"
require "munge/routers/fingerprint"
require "munge/routers/add_index_html"
require "munge/routers/remove_index_basename"
require "munge/transformers/tilt"
