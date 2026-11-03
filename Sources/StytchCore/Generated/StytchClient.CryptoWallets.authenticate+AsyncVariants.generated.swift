// Generated using Sourcery 2.0.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
#if canImport(Combine)
import Combine
#else
import OpenCombineShim
#endif
import Foundation

public extension StytchClient.CryptoWallets {
    /// Wraps Stytch's Crypto wallet [authenticate](https://stytch.com/docs/api/crypto-wallet-authenticate) endpoint. Call this method after the user signs the challenge to validate the signature.
    func authenticate(parameters: AuthenticateParameters, completion: @escaping Completion<AuthenticateResponse>) {
        Task {
            do {
                completion(.success(try await authenticate(parameters: parameters)))
            } catch {
                completion(.failure(error))
            }
        }
    }

    /// Wraps Stytch's Crypto wallet [authenticate](https://stytch.com/docs/api/crypto-wallet-authenticate) endpoint. Call this method after the user signs the challenge to validate the signature.
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
