Dir.glob(File.join(config_path, "*.rb")).each do |file_path|
  binding.eval(File.read(file_path), file_path)
end
