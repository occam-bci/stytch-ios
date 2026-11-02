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
    func updateConnection(parameters: UpdateConnectionParameters, completion: @escaping Completion<SAMLConnectionResponse>) {
        Task {
            do {
                completion(.success(try await updateConnection(parameters: parameters)))
            } catch {
                completion(.failure(error))
            }
        }
    }

    func updateConnection(parameters: UpdateConnectionParameters) -> AnyPublisher<SAMLConnectionResponse, Error> {
        return Deferred {
            Future({ promise in
                Task {
                    do {
                        promise(.success(try await updateConnection(parameters: parameters)))
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
