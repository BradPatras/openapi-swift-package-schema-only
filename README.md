# OpenAPI Swift Package Experiment 
Experimenting with having the OpenAPI config/schema/generator plugin all be contained within a standalone Swift Package for consumption by an iOS app. (using [Apple's OpenAPI Swift Generator](https://github.com/apple/swift-openapi-generator))

##### Tl;dr
You can host your OpenAPI Swift Client code in a barebones<sup>*</sup> swift package containing only the schema file and the Package.swift plugin. This gives two advantages:
1. Your iOS app can simply have an spm dependency to the Client Library without needing to worry about the details of OpenAPI/generating client code.
2. If your schema needs an update, the Client Library can be updated by just dropping in the new schema, committing the change and tagging a new release version to the library's repository.

<sup>*</sup> - The library also needs a single swift function referencing the client code in order for the generator to run.

### Why?
Using Apple's OpenAPI generator the way they recommend means the client API code doesn't get generated until build-time and the generated code is kept out of version control (contained in a temp build directory not readily accessible).  In their examples, the OpenAPI schema file is kept in the root directory of the app/target where the client code is being used.

### The problem
This presents a problem because the iOS app would not typically be the owner of that schema in a real-world usecase where there are multiple client platforms (Android, iOS , Web, etc). The schema is more likely to be housed in a standalone package or alongside the backend server implementation. The client API code should be vended as standalone libraries. 

**Put more simply:** The OpenAPI schema/generator plugin is an implementation detail of the Client Code Package so an iOS client app should never have to know/worry about the OpenAPI generator setup at all.

### The solution (hypothesis)
Since Apple's generator builds the client API code during build time, the iOS client library _should_ only need to inlude the schema file with its `Package.swift` file setup to apply the generator plugin. When an iOS app adds that client swift package as a dependency, the iOS app should be able to access the generated APIs without needing to know/care about the schema file.

### The upstream benefits
If the swift client API package can really be that simple, it makes it very easy for a build pipeline to publish new versions of the client package by just committing the new version of the schema to the package's git repo and then publishing a new release version in the package's github repository. It'd then be up to the iOS consumer apps to update the version of the dependency they're using to the newest version.


### Results
It took 9 iterations with some concessions made, but the basic idea does work almost as I had hoped. (in the following discussion, `Client` refers to the primary piece of generated API code that the consumer apps will interface with)

The main learning was this: If the Client API Library _only_ contains the schema and Package.swift plugin, the client code will not be generated. The Client API Library **needs to be referencing the generated code** in order for it to be built and made available to the consuming application.  This kinda makes sense if you think about it from an efficiency persepctive.

I initially proved this out by creating a public struct in the Client API Library with a property, `let client: Client`. After adding this, the consuming app was able to access the generated code in full (not just via the struct, it could initialize it's own Client directly).

I didn't neccesarily want a public struct in the Client API Library, so I tested out a few more solutions that followed the same idea:
- Declare an empty public extension of the generated `Client`
- Declare a public extension of the generated `Client` with a new initializer defined
- Declare a public extension of the generated `Client` with a static function defined
- Declare a private struct with reference to the generated `Client`

Unfortunately, none of these worked.

What you see in the version 0.0.9 release is what finally _did_ work: A public struct containing a static func that returns an instance of the generated `Client`.
```swift
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
```

This actually ended up serving a good purpose as well. If the consumer apps attempt to initialize the `Client` directly, they'd need to provide a `transport` parameter. I don't want the consumer apps to concern themselves with the type of `transport` the client API library uses, so this static function serves as a way to remove that requirement from the consumers.
