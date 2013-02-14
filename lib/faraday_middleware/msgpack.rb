
require 'faraday_middleware/response_middleware'

module FaradayMiddleware
  module Msgpack
    # Public: parses response bodies with MessagePack.
    class ParseMsgpack < ResponseMiddleware
      dependency 'msgpack'

      define_parser do |body|
        if body.empty?
          nil
        else
          ::MessagePack.unpack(body)
        end
      end
    end
  end
end

Faraday.register_middleware :response, :msgpack => FaradayMiddleware::Msgpack::ParseMsgpack
