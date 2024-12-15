import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

// If this library package doesn't reference the Generated API in some way, then the consumers of this library won't be able to access it either.
public struct APIHelper {
	public static func getClient(
		serverURL: Foundation.URL,
		configuration: Configuration = .init(),
		middlewares: [any ClientMiddleware] = [],
		urlSessionConfiguration: URLSessionTransport.Configuration = .init()
	) -> Client {
		.init(
			serverURL: serverURL,
			configuration: configuration,
			transport: URLSessionTransport(),
			middlewares: middlewares
		)
	}
}
