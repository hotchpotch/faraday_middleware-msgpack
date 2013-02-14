require 'spec_helper'
require 'faraday_middleware/msgpack'

describe FaradayMiddleware::Msgpack::EncodeMsgpack do
  let(:middleware) { described_class.new(lambda{|env| env}) }
  let(:msgpack_body) { {:a => 1}.to_msgpack }

  def process(body, content_type = nil)
    env = {:body => body, :request_headers => Faraday::Utils::Headers.new}
    env[:request_headers]['content-type'] = content_type if content_type
    middleware.call(env)
  end

  def result_body() result[:body] end
  def result_type() result[:request_headers]['content-type'] end

  context "no body" do
    let(:result) { process(nil) }

    it "doesn't change body" do
      expect(result_body).to be_nil
    end

    it "doesn't add content type" do
      expect(result_type).to be_nil
    end
  end

  context "empty body" do
    let(:result) { process('') }

    it "doesn't change body" do
      expect(result_body).to be_empty
    end

    it "doesn't add content type" do
      expect(result_type).to be_nil
    end
  end

  context "string body" do
    let(:result) { process(msgpack_body) }

    it "doesn't change body" do
      expect(result_body).to eq(msgpack_body)
    end

    it "adds content type" do
      expect(result_type).to eq('application/x-msgpack')
    end
  end

  context "object body" do
    let(:result) { process({:a => 1}) }

    it "encodes body" do
      expect(result_body).to eq(msgpack_body)
    end

    it "adds content type" do
      expect(result_type).to eq('application/x-msgpack')
    end
  end

  context "empty object body" do
    let(:result) { process({}) }

    it "encodes body" do
      expect(result_body).to eq({}.to_msgpack)
    end
  end

  context "object body with msgpack type" do
    let(:result) { process({:a => 1}, 'application/x-msgpack; charset=utf-8') }

    it "encodes body" do
      expect(result_body).to eq(msgpack_body)
    end

    it "doesn't change content type" do
      expect(result_type).to eq('application/x-msgpack; charset=utf-8')
    end
  end

  context "object body with incompatible type" do
    let(:result) { process({:a => 1}, 'application/xml; charset=utf-8') }

    it "doesn't change body" do
      expect(result_body).to eq({:a => 1})
    end

    it "doesn't change content type" do
      expect(result_type).to eq('application/xml; charset=utf-8')
    end
  end
end
