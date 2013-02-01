require 'hello_sign/client'

module HelloSign
  module Proxy
    class Settings
      attr_reader :client

      def initialize(client)
        @client = client
      end

      def show
        client.get('/account')
      end

      def update(attributes)
        client.post('/account', :body => attributes)
      end

    end
  end
end
