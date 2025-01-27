# frozen_string_literal: true

module Autentique
  module V2
    module Mutations
      # This module contains mutations for managing folders in Autentique V2.
      module Folders
        # Mutation to create a new folder
        # @param folder [Hash] the folder attributes
        # @return [Hash] the response from the API
        def create_folder(folder:, **options)
          query = mutation_create_folder

          variables = {
            folder: folder
          }

          variables.merge!(options) if options.any?

          execute_query(query, variables)
        end

        # Mutation to delete a folder
        # @param folder_id [String] the UUID of the folder to delete
        # @return [Hash] the response from the API
        def delete_folder(folder_id)
          query = mutation_delete_folder

          variables = { id: folder_id }

          execute_query(query, variables)
        end

        # Mutation to move a document to a folder
        # @param document_id [String] the UUID of the document to move
        # @param folder_id [String] the UUID of the folder to move the document to
        # @param options [Hash] optional parameters for the mutation(context, current_folder_id)
        # @return [Hash] the response from the API
        def moviment_document_to_folder(document_id:, folder_id:, **options)
          query = mutation_moviment_document_to_folder

          variables = {
            document_id: document_id,
            folder_id: folder_id
          }

          variables.merge!(options) if options.any?

          execute_query(query, variables)
        end

        private

        def mutation_create_folder
          <<~GQL
            mutation createFolder($folder: FolderInput!, $type: FolderTypeEnum) {
              createFolder(folder: $folder, type: $type) {
                id
                name
                type
                created_at
              }
            }
          GQL
        end

        def mutation_delete_folder
          <<~GQL
            mutation deleteFolder($id: ID!) {
              deleteFolder(id: $id)
            }
          GQL
        end

        def mutation_move_document_to_folder
          <<~GQL
            mutation moveDocumentToFolder($document_id: UUID!, $folder_id: UUID!, $current_folder_id: UUID) {
              movetDocumentToFolder(document_id: $document_id, folder_id: $folder_id, current_folder_id: $current_folder_id)
            }
          GQL
        end
      end
    end
  end
end
