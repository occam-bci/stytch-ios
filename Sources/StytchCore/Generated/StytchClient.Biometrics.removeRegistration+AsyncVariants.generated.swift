// Generated using Sourcery 2.0.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
#if canImport(Combine)
import Combine
#else
import OpenCombineShim
#endif
import Foundation

#if !os(watchOS) && !os(tvOS)
public extension StytchClient.Biometrics {
    /// Removes the current device's existing biometric registration from both the device itself and from the server.
    func removeRegistration(completion: @escaping Completion<Void>) {
        Task {
            do {
                completion(.success(try await removeRegistration()))
            } catch {
                completion(.failure(error))
            }
        }
    }

    /// Removes the current device's existing biometric registration from both the device itself and from the server.
    func removeRegistration() -> AnyPublisher<Void, Error> {
        return Deferred {
            Future({ promise in
                Task {
                    do {
                        promise(.success(try await removeRegistration()))
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
