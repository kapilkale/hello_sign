require 'helper'
require 'hello_sign/signature_request_proxy'

describe HelloSign::SignatureRequestProxy do
  let(:client)       { double('client') }
  let(:api_response) { double('API response') }
  subject(:sr_proxy) { HelloSign::SignatureRequestProxy.new(client) }

  describe "#client" do
    it "returns the client" do
      expect(sr_proxy.client).to be client
    end
  end

  describe "#send" do
    let(:formatted_request_body) { double('formatted request body') }
    let(:request_parameters)     { double('request parameters') }

    before do
      sr_proxy.request_parameters = request_parameters
      request_parameters.stub(:formatted).and_return(formatted_request_body)
      request_parameters.should_receive(:foo=).with('bar')
      client.should_receive(:post)
        .with('/signature_request/send', :body => formatted_request_body)
        .and_return(api_response)
    end

    it "sends a signature request creation request and returns the result" do
      expect(sr_proxy.send { |params| params.foo = 'bar' }).to eq api_response
    end
  end

  describe "#status" do
    let(:request_id) { 'request_id' }

    before { client.should_receive(:get).with('/signature_request/request_id').and_return(api_response) }

    it "fetches the signature request status and returns the result" do
      expect(sr_proxy.status(request_id)).to eq api_response
    end
  end

  describe "#list" do
    context "when called without options" do
      before { client.should_receive(:get).with('/signature_request/list', :params => {:page => 1}).and_return(api_response) }

      it "fetches the first page of signature requests and returns the result" do
        expect(sr_proxy.list).to eq api_response
      end
    end

    context "when called with a page number" do
      before { client.should_receive(:get).with('/signature_request/list', :params => {:page => 10}).and_return(api_response) }

      it "fetches a list of signature requests for the passed page number and returns the result" do
        expect(sr_proxy.list(:page => 10)).to eq api_response
      end
    end
  end
end
