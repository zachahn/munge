Dir.glob(File.join(config_path, "initializers", "*.rb")).each do |file_path|
  file_abspath = File.expand_path(file_path, File.dirname(__FILE__))

  binding.eval(File.read(file_abspath), file_abspath)
end
