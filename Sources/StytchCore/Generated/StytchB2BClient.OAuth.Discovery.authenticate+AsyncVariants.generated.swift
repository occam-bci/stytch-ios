#if !os(Android)
// Generated using Sourcery 2.0.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
import Combine
import Foundation

public extension StytchB2BClient.OAuth.Discovery {
    /// After an identity provider confirms the identity of a user, this method authenticates the included token and returns a new session object.
    func authenticate(parameters: DiscoveryAuthenticateParameters, completion: @escaping Completion<StytchB2BClient.DiscoveryAuthenticateResponse>) {
        Task {
            do {
                completion(.success(try await authenticate(parameters: parameters)))
            } catch {
                completion(.failure(error))
            }
        }
    }

    /// After an identity provider confirms the identity of a user, this method authenticates the included token and returns a new session object.
    func authenticate(parameters: DiscoveryAuthenticateParameters) -> AnyPublisher<StytchB2BClient.DiscoveryAuthenticateResponse, Error> {
        return Deferred {
            Future({ promise in
                Task {
                    do {
                        promise(.success(try await authenticate(parameters: parameters)))
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
