require "fileutils"
require "pathname"
require "yaml"

require "tilt"

require "munge/version"
require "munge/attribute/content"
require "munge/attribute/metadata"
require "munge/attribute/path"
require "munge/item/base"
require "munge/item/binary"
require "munge/item/text"
require "munge/item/virtual"
require "munge/helper"
require "munge/helper/find"
require "munge/helper/rendering"
require "munge/transformer/tilt"
require "munge/core/source"
require "munge/core/transform"
require "munge/core/transform_scope_factory"
require "munge/core/write"
require "munge/application"
require "munge/runner"

module Munge
  # Your code goes here...
end
