# OpenAPI Swift Package Experiment 
Experimenting with having the OpenAPI config/schema/generator plugin all be contained within a standalone Swift Package for consumption by an iOS app.

### Why?

Using Apple's OpenAPI generator the way they recommend means the client API code doesn't get generated until build-time and the generated code is kept out of version control (contained in a temp build directory not readily accessible).  In their examples, the OpenAPI schema file is kept in the root directory of the app/target where the client code is being used.

### The problem
This presents a problem because the iOS app would not typically be the owner of that schema in a real-world usecase where there are multiple client platforms (Android, iOS , Web, etc). The schema is more likely to be housed in a standalone package or alongside the backend server implementation.  In Apple's simple demos the workflow when making updates to the schema is to just copy/paste the updated schema into the iOS app, but this is not realistic.
