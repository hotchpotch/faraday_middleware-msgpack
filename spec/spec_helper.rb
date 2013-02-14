
require 'rspec'

# Code from faraday_middleware/spec/spec_helper.rb
module ResponseMiddlewareExampleGroup
  def self.included(base)
    base.let(:options) { Hash.new }
    base.let(:headers) { Hash.new }
    base.let(:middleware) {
      described_class.new(lambda {|env|
        Faraday::Response.new(env)
      }, options)
    }
  end

  def process(body, content_type = nil, options = {})
    env = {
      :body => body, :request => options,
      :response_headers => Faraday::Utils::Headers.new(headers)
    }
    env[:response_headers]['content-type'] = content_type if content_type
    middleware.call(env)
  end
end

RSpec.configure do |config|
  config.include ResponseMiddlewareExampleGroup, :type => :response
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
