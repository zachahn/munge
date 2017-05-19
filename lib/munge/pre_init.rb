module Munge
  class PreInit
    include Munge::Util::Import

    def initialize(config_path)
      if !File.exist?(config_path)
        raise Munge::Error::ConfigRbNotFound, config_path
      end

      @config_path = config_path
    end

    def config
      config = Munge::Config.new

      import_to_context(@config_path, binding)

      config
    end

    private

    def __end__
      contents = File.read(@config_path)
      contents.split(/^__END__$/, 2).last
    end
  end
end
