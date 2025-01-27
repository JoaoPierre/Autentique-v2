# frozen_string_literal: true

module Autentique
  module V2
    module Mutations
      # This module contains mutations for managing documents in Autentique V2.
      # It provides functionality for creating, updating, and interacting with documents via GraphQL.
      module Documents
        # Mutation to create a new document
        # @param document [Hash] the document attributes
        # @param signers [Array<Hash>] the signers for the document
        # @param file [File] the file to upload
        # @param options [Hash] optional parameters for the mutation
        # @return [Hash] the response from the API
        def create_document(document:, signers:, file:, **options)
          query = mutation_create_document

          variables = {
            document: document,
            signers: signers,
            file: file
          }

          variables.merge!(options) if options.any?

          execute_query(query, variables, files: file)
        end

        # Mutation to delete a document
        # @param document_id [String] the UUID of the document to delete
        # @return [Hash] the response from the API
        def delete_document(document_id)
          query = mutation_delete_document

          variables = { id: document_id }

          execute_query(query, variables)
        end

        # Mutation to transfer a document
        # @param id [String] the UUID of the document to transfer
        # @param organization_id [Integer] the ID of the organization to transfer the document to
        # @param group_id [Integer] the ID of the group to transfer the document to
        # @param current_group_id [Integer] the ID of the current group
        # @param context [String] the context of the transfer
        # @return [Hash] the response from the API
        def transfer_document(id:, organization_id:, group_id:, **options)
          query = mutation_transfer_document

          variables = {
            id: id,
            organization_id: organization_id,
            group_id: group_id
          }

          variables.merge!(options) if options.any?

          execute_query(query, variables)
        end

        private

        def mutation_create_document
          <<~GRAPHQL
            mutation CreateDocumentMutation(
              $document: DocumentInput!,
              $signers: [SignerInput!]!,
              $file: Upload!
              $sandbox: Boolean,
              $organization_id: UUID,
              $folder_id: UUID
            ) {
              createDocument(
                document: $document,
                signers: $signers,
                file: $file,
                sandbox: $sandbox,
                ordanization_id: $organization_id,
                folder_id: $folder_id
              ) {
                  id
                  name
                  refusable
                  sortable
                  created_at
                  signatures {
                    public_id
                    name
                    email
                    created_at
                    action { name }
                    link { short_link }
                    user { id name email }
                  }
                }
              }
          GRAPHQL
        end

        def mutation_delete_document
          <<~GRAPHQL
            mutation DeleteDocumentMutation($id: UUID!) {
              deleteDocument(id: $id)
            }
          GRAPHQL
        end

        def mutation_transfer_document
          <<~GRAPHQL
            mutation TransferDocumentMutation(
              $id: UUID!,
              $organization_id: int!,
              $group_id: int!,
              $current_group_id: int,
              $context: ContextEnum
            )
            {
              transferDocument(
                id: $id,
                organization_id: $organization_id,
                group_id: $group_id,
                current_group_id: $current_group_id,
                context: $context
              )
            }
          GRAPHQL
        end
      end
    end
  end
end

# Assinando um Documento DONE
# Criando um Documento DONE
# Criar Link de Assinatura DONE
# Removendo um Documento DONE
# Reenviar Assinaturas DONE
# Editando um Documento DONE
# Transferindo um Documento DONE
# Adicionar Signatário DONE
# Remover Signatário DONE
# Aprovar Verificação Biométrica Pendente
# Rejeitar Verificação Biométrica Pendente

# mutation CreateDocumentMutation(
#   $document: DocumentInput!, # Definição das variáveis $document,
#   $signers: [SignerInput!]!, # $signers e $file, com seus respectivos
#   $file: Upload!             # tipos. (Os "!" indicam que são
# ) {                          # parâmetros obrigatórios)
#   createDocument(
#     document: $document,     # Passa para os parâmetros da mutation o
#     signers: $signers,       # valor das variáveis.
#     file: $file,             #
#     organization_id: 123,    # OPCIONAL: Cria em outras organizações do usuário, senão usa a atual
#     folder_id: "a1b2c3"      # OPCIONAL: Cria arquivado em uma pasta
#   ) {
#     id
#     name
#     refusable
#     sortable
#     created_at
#     signatures {
#       public_id
#       name
#       email
#       created_at
#       action { name }
#       link { short_link }
#       user { id name email }
#     }
#   }
# }
