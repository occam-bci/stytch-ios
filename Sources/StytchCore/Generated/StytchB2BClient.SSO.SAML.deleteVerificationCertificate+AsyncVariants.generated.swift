// Generated using Sourcery 2.0.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
#if canImport(Combine)
import Combine
#else
import OpenCombineShim
#endif
import Foundation

#if !os(watchOS)
public extension StytchB2BClient.SSO.SAML {
    func deleteVerificationCertificate(parameters: DeleteVerificationCertificateParameters, completion: @escaping Completion<SAMLDeleteVerificationCertificateResponse>) {
        Task {
            do {
                completion(.success(try await deleteVerificationCertificate(parameters: parameters)))
            } catch {
                completion(.failure(error))
            }
        }
    }

    func deleteVerificationCertificate(parameters: DeleteVerificationCertificateParameters) -> AnyPublisher<SAMLDeleteVerificationCertificateResponse, Error> {
        return Deferred {
            Future({ promise in
                Task {
                    do {
                        promise(.success(try await deleteVerificationCertificate(parameters: parameters)))
                    } catch {
                        promise(.failure(error))
                    }
                }
            })
        }
        .eraseToAnyPublisher()
    }
}
#endif
