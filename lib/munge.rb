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
require "munge/errors"
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
require "munge/system/readers/filesystem"
require "munge/system/processor"
require "munge/system"
require "munge/io/dry_run"
require "munge/io/filesystem"
require "munge/io/noop"
require "munge/write_manager/only_needed"
require "munge/application"
require "munge/config"
require "munge/runner"
require "munge/reporter"
require "munge/pre_init"
require "munge/init"
require "munge/bootloader"

# Extensions
require "munge/helpers/asset_tags"
require "munge/helpers/asset_paths"
require "munge/helpers/capture"
require "munge/helpers/find"
require "munge/helpers/link"
require "munge/helpers/rendering"
require "munge/helpers/tag"
require "munge/helpers/livereload"
require "munge/routers/auto_add_extension"
require "munge/routers/fingerprint"
require "munge/routers/add_directory_index"
require "munge/routers/remove_index_basename"
require "munge/transformers/tilt_transformer"

require "munge/extras/livereload"
