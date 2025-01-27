# frozen_string_literal: true

# Autentique::V2::VERSION = '0.1.0'

require 'httparty'
require 'json'

module Autentique
  module V2
    # Client class for interacting with Autentique V2 GraphQL API
    # @example
    #   client = Autentique::V2::Client.new('your-api-token')
    #   documents = client.list_documents
    class Client
      include HTTParty
      include Mutations::Documents
      include Mutations::Signatures
      include Mutations::Folders
      include Mutations::BiometricVerifications

      base_uri 'https://api.autentique.com.br/v2/graphql'
      format :json

      # Initializes a new Client object
      # @param api_token [String] the API token for the user
      def initialize(api_token)
        @api_token = api_token
      end

      # Executes a GraphQL query or mutation
      # @param query [String] the query or mutation to execute
      # @param variables [Hash] the variables to pass to the query or mutation
      # @param files [Hash] the files to upload
      # @return [Hash] the response from the API
      def execute_query(query, variables = {}, files: nil)
        headers = base_headers
        headers.merge!('Content-Type' => 'application/json') unless files

        response = self.class.post(
          '/',
          headers: headers,
          body: build_body(query, variables, files)
        )

        handle_response(response)
      end

      private

      def base_headers
        { 'Authorization' => "Bearer #{@api_token}" }
      end

      def build_body(query, variables, files)
        if files
          build_multipart_body(query, variables, files)
        else
          build_json_body(query, variables)
        end
      end

      def build_json_body(query, variables)
        {
          query: query,
          variables: variables
        }.to_json
      end

      def build_multipart_body(query, variables, files)
        {
          'operations' => { query: query, variables: variables }.to_json,
          'map' => { '0' => ['variables.file'] }.to_json,
          '0' => files
        }
      end

      def handle_response(response)
        parsed = JSON.parse(response.body)

        raise Error, parsed['errors'].map { |e| e['message'] }.join(', ') if parsed['errors']

        parsed['data']
      rescue JSON::ParserError => e
        raise Error, "Invalid JSON response: #{response.body[0..100]}, #{e.message}"
      end

      def handle_error(response)
        message = case response.code
                  when 404 then 'Resource not found'
                  when 401 then 'Unauthorized - Check your API token'
                  when 422 then 'Invalid request'
                  else "Request failed with status #{response.code}"
                  end

        raise Error, "#{message}: #{response.body[0..100]}"
      end
    end
  end
end
