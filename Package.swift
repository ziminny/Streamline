// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "Streamline",
    platforms: [
        .iOS(.v16), .macOS(.v14)
    ],
    products: [
        .library(
            name: "Streamline",
            targets: ["Streamline"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/socketio/socket.io-client-swift.git",
            from: "16.1.0" // coloque a versão que você quer
        )
    ],
    targets: [
        .target(
            name: "Streamline",
            dependencies: [
                .product(name: "SocketIO", package: "socket.io-client-swift")
            ]
        ),
        .testTarget(
            name: "StreamlineTests",
            dependencies: ["Streamline"]
        ),
    ]
)
