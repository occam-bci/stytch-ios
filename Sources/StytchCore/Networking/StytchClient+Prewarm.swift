#if os(Android)
import Foundation
import FoundationNetworking

public extension StytchClient {
    /// Opens a connection to the Stytch API on the session the SDK's own requests use.
    static func prewarmConnection(publicToken: String) async {
        var request = URLRequest(url: StytchClientConfiguration(publicToken: publicToken).baseUrl)
        request.httpMethod = "HEAD"
        _ = try? await NetworkingClientImplementation.live.networkRequestHandler.urlSession.data(for: request)
    }
}
#endif
