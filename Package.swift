// swift-tools-version:5.9
import PackageDescription

let package = Package(
  name: "Lottie",
  platforms: [
    .iOS(.v13),
    .macOS(.v10_15),
    .tvOS(.v13),
    .visionOS(.v1)
  ],
  products: [
    .library(
      name: "Lottie",
      targets: ["Lottie"]
    ),
    .library(
      name: "Lottie-Dynamic",
      type: .dynamic,
      targets: ["Lottie"]
    ),
  ],
  targets: [
    .target(
      name: "Lottie",
      path: "Sources",
      exclude: [
        "Private/EmbeddedLibraries/README.md",
        "Private/EmbeddedLibraries/ZipFoundation/README.md",
        "Private/EmbeddedLibraries/EpoxyCore/README.md",
        "Private/EmbeddedLibraries/LRUCache/README.md",
      ],
      resources: [
        .copy("PrivacyInfo.xcprivacy")
      ]
    )
  ]
)
