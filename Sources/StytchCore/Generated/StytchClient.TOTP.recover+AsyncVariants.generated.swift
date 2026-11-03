// Generated using Sourcery 2.0.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
#if canImport(Combine)
import Combine
#else
import OpenCombineShim
#endif
import Foundation

public extension StytchClient.TOTP {
    /// Wraps Stytch's [recover](https://stytch.com/docs/api/totp-recover) endpoint. Call this method to authenticate a recovery code for a TOTP instance.
    func recover(parameters: RecoverParameters, completion: @escaping Completion<RecoverResponse>) {
        Task {
            do {
                completion(.success(try await recover(parameters: parameters)))
            } catch {
                completion(.failure(error))
            }
        }
    }

    /// Wraps Stytch's [recover](https://stytch.com/docs/api/totp-recover) endpoint. Call this method to authenticate a recovery code for a TOTP instance.
    func recover(parameters: RecoverParameters) -> AnyPublisher<RecoverResponse, Error> {
        return Deferred {
            Future({ promise in
                Task {
                    do {
                        promise(.success(try await recover(parameters: parameters)))
                    } catch {
                        promise(.failure(error))
                    }
                }
            })
        }
        .eraseToAnyPublisher()
    }
}
