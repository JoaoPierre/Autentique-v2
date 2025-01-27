# frozen_string_literal: true

module Autentique
  module V2
    module Multations
      # This module contains mutations for managing signatures in Autentique V2.
      module Signatures
        # Mutation to create a sign link
        # @param public_id [String] the public ID of the signature
        # @return [Hash] the response from the API
        # Public ID is the ID of the signature that is used to generate a sign link
        def create_sign_link(public_id)
          query = mutation_create_sign_link

          variables = { public_id: public_id }

          execute_query(query, variables)
        end

        # Mutation to sign a document
        # @param id [String] the UUID of the document to sign
        # @return [Hash] the response from the API
        # This mutation is used to sign a document that has been shared with the API KEY Owner
        def sign_document(id)
          query = mutation_sign_document

          variables = { id: id }

          execute_query(query, variables)
        end

        # Mutation to resend signatures
        # @param public_ids [Array<String>] the public IDs of the signatures to resend
        # @return [Hash] the response from the API
        def resend_signatures(public_ids)
          query = mutation_resend_signatures

          variables = { public_ids: public_ids }

          execute_query(query, variables)
        end

        def add_signer(document_id:, signer:)
          query = mutation_create_signer

          variables = {
            document_id: document_id,
            signer: signer
          }

          execute_query(query, variables)
        end

        def remove_signer(public_id:, document_id:)
          query = mutation_remove_signer

          variables = {
            public_id: public_id,
            document_id: document_id
          }

          execute_query(query, variables)
        end

        private

        def mutation_create_sign_link
          <<~GRAPHQL
            mutation CreateSignLinkMutation($public_id: UUID!) {
              createSignLink(public_id: $public_id) {
                short_link
              }
            }
          GRAPHQL
        end

        def mutation_sign_document
          <<~GRAPHQL
            mutation SignDocumentMutation($id: UUID!) {
              signDocument(id: $id)
            }
          GRAPHQL
        end

        def mutation_resend_signatures
          <<~GRAPHQL
            mutation ResendSignaturesMutation($public_ids: [UUID!]!) {
              resendSignatures(public_ids: $public_ids)
            }
          GRAPHQL
        end

        def mutation_add_signer
          <<~GRAPHQL
            mutation AddSignerMutation($document_id: UUID!,$signer: SignerInput){
              createSigner(document_id: $document_id,signer: $signer){
                public_id
                name
                email
                delivery_method
                action { name }
                link {
                  id
                  short_link
                }
                created_at
              }
            }
          GRAPHQL
        end

        def mutation_remove_signer
          <<~GRAPHQL
            mutation RemoveSignerMutation($public_id: UUID!, $document_id: UUID!){
              removeSigner(public_id: $public_id, document_id: $document_id)
            }
          GRAPHQL
        end
      end
    end
  end
end
# Remover Signatário
