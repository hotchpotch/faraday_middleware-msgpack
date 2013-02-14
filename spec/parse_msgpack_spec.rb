require 'spec_helper'
require 'faraday_middleware/msgpack'

describe FaradayMiddleware::Msgpack::ParseMsgpack, :type => :response do
  let(:msgpack_body) { {:a => 1}.to_msgpack }

  context "no type matching" do
    it "doesn't change nil body" do
      expect(process(nil).body).to be_nil
    end

    it "returns false for empty body" do
      expect(process('').body).to be_false
    end

    it "parses msgpack body" do
      response = process(msgpack_body)
      expect(response.body).to eq('a' => 1)
      expect(response.env[:raw_body]).to be_nil
    end
  end

  context "with preserving raw" do
    let(:options) { {:preserve_raw => true} }

    it "parses msgpack body" do
      response = process(msgpack_body)
      expect(response.body).to eq('a' => 1)
      expect(response.env[:raw_body]).to eq(msgpack_body)
    end

    it "can opt out of preserving raw" do
      response = process(msgpack_body, nil, :preserve_raw => false)
      expect(response.env[:raw_body]).to be_nil
    end
  end

  context "with regexp type matching" do
    let(:options) { {:content_type => /\bmsgpack$/} }

    it "parses msgpack body of correct type" do
      response = process(msgpack_body, 'application/x-msgpack')
      expect(response.body).to eq('a' => 1)
    end

    it "ignores msgpack body of incorrect type" do
      response = process(msgpack_body, 'text/yaml-xml')
      expect(response.body).to eq(msgpack_body)
    end
  end

  it "chokes on invalid msgpack" do
    expect{ process('hello') }.to raise_error(Faraday::Error::ParsingError)
  end
end
