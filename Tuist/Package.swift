// swift-tools-version: 5.9
import PackageDescription

#if TUIST
    import ProjectDescription

    let packageSettings = PackageSettings(
        productTypes: [
            "RxSwift": .framework,
            "NMapsMap": .staticFramework,
            "GoogleMobileAds": .staticFramework
        ]
    )
#endif

let package = Package(
    name: "ExternalDependencies",
    platforms: [.iOS(.v15)],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.5.0")),
        .package(url: "https://github.com/Moya/Moya.git", .upToNextMajor(from: "15.0.0")),
        .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.1")),
        .package(url: "https://github.com/navermaps/SPM-NMapsMap", .upToNextMajor(from: "3.21.0")),
        .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git", .upToNextMajor(from: "12.6.0"))
    ]
)
