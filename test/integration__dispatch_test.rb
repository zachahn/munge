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
    assert_match(%r{assets/stylesheets/basic-}, out(build_io))

    update_io = capture_subprocess_io do
      Dir.chdir("sandbox/#{project_name}") do
        Munge::Cli::Dispatch.start(["update"])
      end
    end

    assert_match("exist  config", out(update_io))
    assert_match("identical  config/_asset_roots.rb", out(update_io))

    view_io = capture_subprocess_io do
      Dir.chdir("sandbox/#{project_name}") do
        ENV["MUNGE_ENV"] = "production"
        pid = fork { Munge::Cli::Dispatch.start(["view"]) }
        sleep(2)
        Process.kill("INT", pid)
        Process.wait
      end
    end

    assert_match("INFO  WEBrick", err(view_io))

    server_io = capture_subprocess_io do
      Dir.chdir("sandbox/#{project_name}") do
        ENV["MUNGE_ENV"] = "development"
        pid = fork { Munge::Cli::Dispatch.start(["server"]) }
        sleep(2)
        Process.kill("INT", pid)
        Process.wait
      end
    end

    assert_match("created   assets/stylesheets/basic.", out(server_io))
    assert_match("INFO  WEBrick", err(server_io))
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
end
