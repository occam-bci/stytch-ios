// Generated using Sourcery 2.0.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
#if canImport(Combine)
import Combine
#else
import OpenCombineShim
#endif
import Foundation

public extension StytchClient.CryptoWallets {
    /// Wraps Stytch's Crypto wallet [authenticate_start](https://stytch.com/docs/api/crypto-wallet-authenticate-start) endpoint. Call this method to load the challenge data. Pass this challenge to your user's wallet for signing.
    func authenticateStart(parameters: AuthenticateStartParameters, completion: @escaping Completion<AuthenticateStartResponse>) {
        Task {
            do {
                completion(.success(try await authenticateStart(parameters: parameters)))
            } catch {
                completion(.failure(error))
            }
        }
    }

    /// Wraps Stytch's Crypto wallet [authenticate_start](https://stytch.com/docs/api/crypto-wallet-authenticate-start) endpoint. Call this method to load the challenge data. Pass this challenge to your user's wallet for signing.
    func authenticateStart(parameters: AuthenticateStartParameters) -> AnyPublisher<AuthenticateStartResponse, Error> {
        return Deferred {
            Future({ promise in
                Task {
                    do {
                        promise(.success(try await authenticateStart(parameters: parameters)))
                    } catch {
                        promise(.failure(error))
                    }
                }
            })
        }
        .eraseToAnyPublisher()
    }
}
