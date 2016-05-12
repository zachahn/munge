# Copyright (c) 2007-2015 Denis Defreyne and contributors
# Copyright (c) 2015 Zach Ahn
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# https://github.com/nanoc/nanoc/blob/fdf8b28/lib/nanoc/cli/commands/view.rb#L17-L53

require "adsf"
require "rack"

module Munge
  module Cli
    module Commands
      class View
        def initialize(bootloader, host:, port:, build_root: nil)
          config = bootloader.config
          @host  = host
          @port  = port
          root   = File.expand_path(build_root || config[:output], bootloader.root_path)

          @app =
            Rack::Builder.new do
              use Rack::ShowExceptions
              use Rack::Head
              use Adsf::Rack::IndexFileFinder, root: root
              run Rack::File.new(root)
            end
        end

        def call
          Signal.trap("INT") do
            # Prints a newline after the terminal prints `^C`
            puts
            Rack::Handler::WEBrick.shutdown
          end

          Rack::Handler::WEBrick.run(@app, Host: @host, Port: @port)
        end
      end
    end
  end
end
