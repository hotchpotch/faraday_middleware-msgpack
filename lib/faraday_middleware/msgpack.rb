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

    # base from FaradayMiddeware::EncodeJson
    class EncodeMsgpack < Faraday::Middleware
      CONTENT_TYPE = 'Content-Type'.freeze
      MIME_TYPE    = 'application/x-msgpack'.freeze

      dependency do
        require 'msgpack'
      end

      def call(env)
        match_content_type(env) do |data|
          env[:body] = encode data
        end
        @app.call env
      end

      def encode(data)
        data.to_msgpack
      end

      def match_content_type(env)
        if process_request?(env)
          env[:request_headers][CONTENT_TYPE] ||= MIME_TYPE
          yield env[:body] unless env[:body].respond_to?(:to_str)
        end
      end

      def process_request?(env)
        type = request_type(env)
        has_body?(env) and (type.empty? or type == MIME_TYPE)
      end

      def has_body?(env)
        body = env[:body] and !(body.respond_to?(:to_str) and body.empty?)
      end

      def request_type(env)
        type = env[:request_headers][CONTENT_TYPE].to_s
        type = type.split(';', 2).first if type.index(';')
        type
      end
    end
  end
end

if Faraday::Middleware.respond_to? :register_middleware
  # faraday >= 0.9
  Faraday::Response.register_middleware :msgpack => FaradayMiddleware::Msgpack::ParseMsgpack
  Faraday::Request.register_middleware :msgpack => FaradayMiddleware::Msgpack::EncodeMsgpack
else
  # faraday < 0.9
  Faraday.register_middleware :response, :msgpack => FaradayMiddleware::Msgpack::ParseMsgpack
  Faraday.register_middleware :request, :msgpack => FaradayMiddleware::Msgpack::EncodeMsgpack
end
