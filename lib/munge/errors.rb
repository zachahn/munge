module Munge
  module Errors
    class Base < StandardError
    end

    module ErrorWithIdentifier
      def initialize(identifier)
        @identifier = identifier
      end
    end

    class DoubleWriteError < Base
      include ErrorWithIdentifier

      def message
        "attempted to write #{@identifier} twice"
      end
    end

    class DuplicateItemError < Base
      include ErrorWithIdentifier

      def message
        "item with id `#{@identifier}` already exists"
      end
    end

    class ItemNotFoundError < Base
      include ErrorWithIdentifier

      def message
        "item not found (#{@identifier})"
      end
    end

    class ItemHasNoRouteError < Base
      include ErrorWithIdentifier

      def message
        "item `#{@identifier}` has no route"
      end
    end

    class DuplicateTransformerError < Base
      include ErrorWithIdentifier

      def message
        "already registered transformer `#{@identifier}`"
      end
    end

    class TransformerNotFoundError < Base
      include ErrorWithIdentifier

      def message
        "transformer `#{@identifier}` is not installed"
      end
    end

    class InvalidRouterError < Base
      include ErrorWithIdentifier

      def message
        "invalid router with type #{@identifier}"
      end
    end

    class ConfigRbNotFound < Base
      include ErrorWithIdentifier

      def message
        "Expected to find config file: #{@identifier}\n" \
        "Are you in the correct directory, or did you run `munge init`?"
      end
    end

    class ConfigKeyNotFound < Base
      include ErrorWithIdentifier

      def message
        "Couldn't find config for key: #{@identifier.inspect}"
      end
    end
  end
end
