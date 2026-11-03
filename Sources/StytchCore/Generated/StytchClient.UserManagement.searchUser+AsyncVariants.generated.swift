// Generated using Sourcery 2.0.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
#if canImport(Combine)
import Combine
#else
import OpenCombineShim
#endif
import Foundation

public extension StytchClient.UserManagement {
    /// Searches for a user by their email address
    func searchUser(email: String, completion: @escaping Completion<UserSearchResponse>) {
        Task {
            do {
                completion(.success(try await searchUser(email: email)))
            } catch {
                completion(.failure(error))
            }
        }
    }

    /// Searches for a user by their email address
    func searchUser(email: String) -> AnyPublisher<UserSearchResponse, Error> {
        return Deferred {
            Future({ promise in
                Task {
                    do {
                        promise(.success(try await searchUser(email: email)))
                    } catch {
                        promise(.failure(error))
                    }
                }
            })
        }
        .eraseToAnyPublisher()
    }
}
