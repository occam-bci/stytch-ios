// Generated using Sourcery 2.0.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
#if canImport(Combine)
import Combine
#else
import OpenCombineShim
#endif
import Foundation

public extension StytchClient.UserManagement {
    func update(parameters: UpdateParameters, completion: @escaping Completion<NestedUserResponse>) {
        Task {
            do {
                completion(.success(try await update(parameters: parameters)))
            } catch {
                completion(.failure(error))
            }
        }
    }

    func update(parameters: UpdateParameters) -> AnyPublisher<NestedUserResponse, Error> {
        return Deferred {
            Future({ promise in
                Task {
                    do {
                        promise(.success(try await update(parameters: parameters)))
                    } catch {
                        promise(.failure(error))
                    }
                }
            })
        }
        .eraseToAnyPublisher()
    }
}
