#if !os(Android)
// Generated using Sourcery 2.0.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
import Combine
import Foundation

public extension StytchB2BClient.OTP.SMS {
    /// Send a one-time passcode (OTP) to a user using their phone number via SMS.
    func send(parameters: SendParameters, completion: @escaping Completion<BasicResponse>) {
        Task {
            do {
                completion(.success(try await send(parameters: parameters)))
            } catch {
                completion(.failure(error))
            }
        }
    }

    /// Send a one-time passcode (OTP) to a user using their phone number via SMS.
    func send(parameters: SendParameters) -> AnyPublisher<BasicResponse, Error> {
        return Deferred {
            Future({ promise in
                Task {
                    do {
                        promise(.success(try await send(parameters: parameters)))
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
