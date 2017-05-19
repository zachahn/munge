require "fileutils"
require "forwardable"
require "pathname"
require "yaml"
require "cgi"

require "tilt"

if Gem::Specification.find_all_by_name("pry-byebug").any?
  require "pry-byebug"
elsif Gem::Specification.find_all_by_name("pry").any?
  require "pry"
end

# Core
require "munge/version"
require "munge/item"
require "munge/error"
require "munge/util/path"
require "munge/util/symbol_hash"
require "munge/util/boolean_regex"
require "munge/util/import"
require "munge/system/router"
require "munge/system/router/itemish"
require "munge/system/item_factory"
require "munge/system/item_factory/content_parser"
require "munge/system/item_factory/item_identifier"
require "munge/system/collection"
require "munge/system/reader"
require "munge/system/processor"
require "munge/system"
require "munge/vfs/dry_run"
require "munge/vfs/filesystem"
require "munge/write_manager/all"
require "munge/write_manager/only_needed"
require "munge/application"
require "munge/config"
require "munge/runner"
require "munge/reporter"
require "munge/cleaner"
require "munge/pre_init"
require "munge/init"
require "munge/bootloader"

# Extensions
require "munge/helper/asset_tags"
require "munge/helper/asset_paths"
require "munge/helper/capture"
require "munge/helper/find"
require "munge/helper/link"
require "munge/helper/rendering"
require "munge/helper/tag"
require "munge/helper/livereload"
require "munge/router/auto_add_extension"
require "munge/router/fingerprint"
require "munge/router/add_directory_index"
require "munge/router/remove_index_basename"
require "munge/transformer/tilt_transformer"

require "munge/extra/livereload"
