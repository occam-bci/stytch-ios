// Generated using Sourcery 2.0.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
#if canImport(Combine)
import Combine
#else
import OpenCombineShim
#endif
import Foundation

public extension StytchClient.UserManagement {
    /// Deletes, by id, an existing authentication factor associated with the current user.
    func deleteFactor(_ factor: AuthenticationFactor, completion: @escaping Completion<NestedUserResponse>) {
        Task {
            do {
                completion(.success(try await deleteFactor(factor)))
            } catch {
                completion(.failure(error))
            }
        }
    }

    /// Deletes, by id, an existing authentication factor associated with the current user.
    func deleteFactor(_ factor: AuthenticationFactor) -> AnyPublisher<NestedUserResponse, Error> {
        return Deferred {
            Future({ promise in
                Task {
                    do {
                        promise(.success(try await deleteFactor(factor)))
                    } catch {
                        promise(.failure(error))
                    }
                }
            })
        }
        .eraseToAnyPublisher()
    }
}
