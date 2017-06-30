def app
  Thread.current.thread_variable_get("app")
end

def conglomerate
  Thread.current.thread_variable_get("conglomerate")
end

def config
  Thread.current.thread_variable_get("config")
end

def root_path
  Thread.current.thread_variable_get("root_path")
end

Dir.glob("lib/**/*.rb").sort.each do |file|
  if File.file?(file)
    load file
  end
end
