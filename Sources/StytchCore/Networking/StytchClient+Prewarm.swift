#if os(Android)
import Foundation
import FoundationNetworking

public extension StytchClient {
    /// Android HTTP transport installed by the app; `nil` keeps the SDK's URLSession.
    nonisolated(unsafe) static var dataTransport: (@Sendable (URLRequest) async throws -> (Data, URLResponse))?

    /// Opens a connection to the Stytch API on the transport the SDK's own requests use.
    static func prewarmConnection(publicToken: String) async {
        var request = URLRequest(url: StytchClientConfiguration(publicToken: publicToken).baseUrl)
        request.httpMethod = "HEAD"
        _ = try? await NetworkingClientImplementation.live.networkRequestHandler.defaultRequestHandler(request: request)
    }
}
#endif
