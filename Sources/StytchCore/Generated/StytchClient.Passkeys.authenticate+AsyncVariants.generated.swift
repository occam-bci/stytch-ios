// Generated using Sourcery 2.0.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
#if canImport(Combine)
import Combine
#else
import OpenCombineShim
#endif
import Foundation

#if !os(watchOS)
@available(macOS 12.0, iOS 16.0, tvOS 16.0, *)
public extension StytchClient.Passkeys {
    /// Provides second-factor authentication for the authenticated-user via an existing passkey.
    func authenticate(parameters: AuthenticateParameters, completion: @escaping Completion<AuthenticateResponse>) {
        Task {
            do {
                completion(.success(try await authenticate(parameters: parameters)))
            } catch {
                completion(.failure(error))
            }
        }
    }

    /// Provides second-factor authentication for the authenticated-user via an existing passkey.
    func authenticate(parameters: AuthenticateParameters) -> AnyPublisher<AuthenticateResponse, Error> {
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
