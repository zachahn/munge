module Munge
  module Extra
    module Livereload
      class Server < Reel::Server::HTTP
        def initialize(host = "127.0.0.1", port = 35729)
          super(host, port, &method(:on_connection))
          @update_client = UpdateClient.new(self)
          @messaging = Messaging.new
          @sockets = []
        end

        def notify_reload(changed_files)
          @sockets.select! do |socket|
            begin
              changed_files.each do |file|
                socket << @messaging.reload(file)
              end

              true
            rescue Reel::SocketError
              false
            end
          end
        end

        private

        def on_connection(connection)
          connection.each_request do |request|
            if request.websocket?
              handle_websocket(connection, request)
            else
              handle_request(request)
            end
          end
        end

        def handle_websocket(_connection, request)
          socket = request.websocket
          if socket.url == "/livereload"
            # Ordering of handshake doesn't seem to matter
            socket << @messaging.hello

            if @messaging.valid_handshake?(socket.read)
              @sockets.push(socket)
            end
          end
        rescue Reel::SocketError
          print_error("error with livereload socket")
        end

        def handle_request(request)
          if request.path == "/livereload.js"
            livejs = File.expand_path("vendor/livereload.js", File.dirname(__FILE__))
            request.respond(:ok, File.read(livejs))
          else
            request.respond(:not_found, "not found")
          end
        end

        def print_error(message)
          $stderr.puts(message)
        end
      end
    end
  end
end
