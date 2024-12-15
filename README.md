# OpenAPI Swift Package Experiment 
Experimenting with having the OpenAPI config/schema/generator plugin all be contained within a standalone Swift Package for consumption by an iOS app.

### Why?
Using Apple's OpenAPI generator the way they recommend means the client API code doesn't get generated until build-time and the generated code is kept out of version control (contained in a temp build directory not readily accessible).  In their examples, the OpenAPI schema file is kept in the root directory of the app/target where the client code is being used.

### The problem
This presents a problem because the iOS app would not typically be the owner of that schema in a real-world usecase where there are multiple client platforms (Android, iOS , Web, etc). The schema is more likely to be housed in a standalone package or alongside the backend server implementation. The client API code should be vended as standalone libraries. 

**Put more simply:** The OpenAPI schema/generator plugin is an implementation detail of the Client Code Package so an iOS client app should never have to know/worry about the OpenAPI generator setup at all.

### The solution (hypothesis)
Since Apple's generator builds the client API code during build time, the iOS client library _should_ only need to inlude the schema file with its `Package.swift` file setup to apply the generator plugin. When an iOS app adds that client swift package as a dependency, the iOS app should be able to access the generated APIs without needing to know/care about the schema file.

### The upstream benefits
If the swift client API package can really be that simple, it makes it very easy for a build pipeline to publish new versions of the client package by just committing the new version of the schema to the package's git repo and then publishing a new release version in the package's github repository. It'd then be up to the iOS consumer apps to update the version of the dependency they're using to the newest version.