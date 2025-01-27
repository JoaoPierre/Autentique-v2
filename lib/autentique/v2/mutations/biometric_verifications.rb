module Autentique
  module V2
    module Mutations
      # This module contains mutations for managing biometric verifications in Autentique V2.
      module BiometricVerifications
        # Mutation to approve a biometric verification
        def approve_biometric_verification(verification_id:, public_id:)
          query = mutation_approve_biometric_verification

          variables = {
            verification_id: verification_id,
            public_id: public_id
          }

          execute_query(query, variables)
        end

        def reject_biometric_verification(verification_id:, public_id:)
          query = mutation_reject_biometric_verification

          variables = {
            verification_id: verification_id,
            public_id: public_id
          }

          execute_query(query, variables)
        end

        private

        def mutation_approve_biometric_verification
          <<~GQL
            mutation approveBiometricVerification($verification_id: ID!, public_id: UUID!) {
              approveBiometric(verification_id: $verification_id, public_id: public_id) {
                public_id
                name
                email
                delivery_method
                user{
                  id
                  name
                  email
                  phone
                }
                verifications{
                  id
                  type
                  verify_phone
                  payload {
                    url
                    reference
                  }
                  user {
                    images
                    confidence
                  }
                  verified_at
                  max_attempt
                  logs_attempt
                }
              }
            }
          GQL
        end

        def mutation_reject_biometric_verification
          <<~GQL
            mutation rejectBiometricVerification($verification_id: ID!, public_id: UUID!) {
              rejectBiometric(verification_id: $verification_id, public_id: public_id) {
                public_id
                name
                email
                delivery_method
                user{
                  id
                  name
                  email
                  phone
                }
                verifications{
                  id
                  type
                  verify_phone
                  payload {
                    url
                    reference
                  }
                  user {
                    images
                    confidence
                  }
                  verified_at
                  max_attempt
                  logs_attempt
                }
              }
            }
          GQL
        end
      end
    end
  end
end
