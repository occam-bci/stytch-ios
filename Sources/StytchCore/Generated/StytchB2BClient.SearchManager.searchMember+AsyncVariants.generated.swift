// Generated using Sourcery 2.0.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
#if canImport(Combine)
import Combine
#else
import OpenCombineShim
#endif
import Foundation

public extension StytchB2BClient.SearchManager {
    /// Search for a member of any organization by their email and organization id
    func searchMember(searchMemberParameters: SearchMemberParameters, completion: @escaping Completion<SearchMemberResponse>) {
        Task {
            do {
                completion(.success(try await searchMember(searchMemberParameters: searchMemberParameters)))
            } catch {
                completion(.failure(error))
            }
        }
    }

    /// Search for a member of any organization by their email and organization id
    func searchMember(searchMemberParameters: SearchMemberParameters) -> AnyPublisher<SearchMemberResponse, Error> {
        return Deferred {
            Future({ promise in
                Task {
                    do {
                        promise(.success(try await searchMember(searchMemberParameters: searchMemberParameters)))
                    } catch {
                        promise(.failure(error))
                    }
                }
            })
        }
        .eraseToAnyPublisher()
    }
}
