Dir.glob(File.join(config_path, "*.rb")).sort.each do |file_path|
  binding.eval(File.read(file_path), file_path)
end
