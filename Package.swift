import PackageDescription

let package = Package(
    name: "MXviewToGo",
    dependencies: [
        .Package(url: "https://github.com/socketio/socket.io-client-swift", majorVersion: 8)
    ]
)
