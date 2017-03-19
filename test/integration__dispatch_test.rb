require "test_helper"

class IntegrationDispatchTest < TestCase
  def setup
    if !ENV["RUN_FILESYSTEM_INTEGRATION_TESTS"]
      skip
    end
  end

  def teardown
    if File.exist?("sandbox/#{project_name}")
      FileUtils.rm_r("sandbox/#{project_name}")
    end
  end

  test "#init and #update and #build and #view and #server" do
    init_io = capture_subprocess_io do
      Dir.chdir("sandbox") do
        Munge::Cli::Dispatch.start(["init", project_name])
      end
    end

    assert_match("create  Gemfile", out(init_io))
    assert_match("run  bundle install", out(init_io))

    build_io = capture_subprocess_io do
      Dir.chdir("sandbox/#{project_name}") do
        ENV["MUNGE_ENV"] = "production"
        Munge::Cli::Dispatch.start(["build"])
      end
    end

    assert_match("Started build", out(build_io))
    assert_match(%r{assets/basic-}, out(build_io))

    update_io = capture_subprocess_io do
      Dir.chdir("sandbox/#{project_name}") do
        Munge::Cli::Dispatch.start(["update"])
      end
    end

    assert_match("exist  lib", out(update_io))
    assert_match("identical  lib/_asset_roots.rb", out(update_io))

    @view_server_responded = false
    _view_io = capture_subprocess_io do
      Dir.chdir("sandbox/#{project_name}") do
        ENV["MUNGE_ENV"] = "production"
        view_port = new_port_number
        pid = Process.fork { Munge::Cli::Dispatch.start(["view", "--port", view_port.to_s]) }
        10.times do
          sleep(1)
          if server_responded?("http://127.0.0.1:#{view_port}/")
            @view_server_responded = true
            break
          end
        end
        Process.kill("INT", pid)
        Process.wait
      end
    end

    assert_equal(true, @view_server_responded)

    @server_server_responded = false
    _server_io = capture_subprocess_io do
      Dir.chdir("sandbox/#{project_name}") do
        ENV["MUNGE_ENV"] = "development"
        server_port = new_port_number
        pid = Process.fork { Munge::Cli::Dispatch.start(["server", "--no-livereload", "--port", server_port.to_s]) }
        10.times do
          sleep(1)
          if server_responded?("http://127.0.0.1:#{server_port}/")
            @server_server_responded = true
            break
          end
        end
        Process.kill("INT", pid)
        Process.wait
      end
    end

    built_file = Dir.glob("sandbox/#{project_name}/tmp/development-build/assets/basic*")

    assert_kind_of(String, built_file.first)
    assert_equal(true, @server_server_responded)
  end

  test "#version" do
    version_io = capture_io do
      Dir.chdir("sandbox") do
        Munge::Cli::Dispatch.start(["version"])
      end
    end

    assert_match(/^munge [0-9\.]+$/, out(version_io))
  end

  private

  def project_name
    @project_name ||= (Time.now.to_f * 1000).to_i.to_s
  end

  def out(io)
    io.first
  end

  def err(io)
    io.last
  end

  # @return [Number] random unclaimable port number
  def new_port_number
    min_port = 49152 + 1000
    max_port = 65535 - 1000

    rand(min_port..max_port)
  end

  def server_responded?(url)
    if Net::HTTP.get(URI(url))
      return true
    else
      return false
    end
  rescue
    return false
  end
end
