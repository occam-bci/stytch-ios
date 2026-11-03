// Generated using Sourcery 2.0.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
#if canImport(Combine)
import Combine
#else
import OpenCombineShim
#endif
import Foundation

public extension StytchB2BClient.RecoveryCodes {
    /// Get the recovery codes for an authenticated member
    func get(completion: @escaping Completion<RecoveryCodesResponse>) {
        Task {
            do {
                completion(.success(try await get()))
            } catch {
                completion(.failure(error))
            }
        }
    }

    /// Get the recovery codes for an authenticated member
    func get() -> AnyPublisher<RecoveryCodesResponse, Error> {
        return Deferred {
            Future({ promise in
                Task {
                    do {
                        promise(.success(try await get()))
                    } catch {
                        promise(.failure(error))
                    }
                }
            })
        }
        .eraseToAnyPublisher()
    }
}
