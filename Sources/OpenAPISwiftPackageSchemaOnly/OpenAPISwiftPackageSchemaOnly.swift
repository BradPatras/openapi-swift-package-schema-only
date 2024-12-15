import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

private struct GeneratorHelper {
	let client: Client
}

// If this library package doesn't reference the Generated API in some way, then the consumers of this library won't be able to access it either.
public extension Client {
	init(
		serverURL: Foundation.URL,
		configuration: Configuration = .init(),
		middlewares: [any ClientMiddleware] = [],
		urlSessionConfiguration: URLSessionTransport.Configuration = .init()
	) {
		self.init(
			serverURL: serverURL,
			configuration: configuration,
			transport: URLSessionTransport(),
			middlewares: middlewares
		)
	}
}
