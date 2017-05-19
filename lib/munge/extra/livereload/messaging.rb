module Munge
  module Extra
    module Livereload
      class Messaging
        def hello
          JSON.generate(
            command: "hello",
            protocols: [the_protocol],
            serverName: "munge-livereload"
          )
        end

        def reload(changed_file)
          JSON.generate(
            command: "reload",
            path: changed_file,
            liveCSS: "false"
          )
        end

        def valid_handshake?(socket_data)
          client_handshake = JSON.parse(socket_data)

          return false if client_handshake["command"] != "hello"
          return false if !client_handshake["protocols"].include?(the_protocol)

          true
        rescue
          false
        end

        private

        def the_protocol
          "http://livereload.com/protocols/official-7".freeze
        end
      end
    end
  end
end
