// swift-tools-version:5.5

import Foundation
import PackageDescription

let package = Package(
    name: "Stytch",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8),
    ],
    products: [
        .library(name: "StytchCore", targets: ["StytchCore"]),
        .library(name: "StytchUI", targets: ["StytchUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/marmelroy/PhoneNumberKit", from: "4.1.4"),
        .package(url: "https://github.com/GoogleCloudPlatform/recaptcha-enterprise-mobile-sdk", from: "18.8.1"),
        // Android: SwiftyJSON 5.0.2's NSNumber operators are ambiguous against swift-corelibs Foundation;
        // use the patched fork at forks/SwiftyJSON (commit 02faf59) instead of the published pin.
        ProcessInfo.processInfo.environment["TARGET_OS_ANDROID"] != nil
            ? .package(name: "SwiftyJSON", path: "../SwiftyJSON")
            : .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", from: "5.0.2"),
        .package(url: "https://github.com/stytchauth/stytch-ios-dfp.git", from: "1.0.5"),
        .package(url: "https://github.com/OpenCombine/OpenCombine.git", from: "0.14.0"),
        .package(url: "https://github.com/apple/swift-crypto.git", from: "3.0.0"),
    ],
    targets: [
        .target(
            name: "StytchUI",
            dependencies: [
                .target(name: "StytchCore"),
                .product(name: "PhoneNumberKit", package: "PhoneNumberKit"),
            ],
            resources: [
                .process("PrivacyInfo.xcprivacy"),
            ]
        ),
        .target(
            name: "StytchCore",
            dependencies: [
                .product(name: "RecaptchaEnterprise", package: "recaptcha-enterprise-mobile-sdk", condition: .when(platforms: [.iOS])),
                .product(name: "StytchDFP", package: "stytch-ios-dfp", condition: .when(platforms: [.iOS])),
                .product(name: "SwiftyJSON", package: "SwiftyJSON"),
                .product(name: "OpenCombineShim", package: "OpenCombine", condition: .when(platforms: [.android])),
                .product(name: "Crypto", package: "swift-crypto", condition: .when(platforms: [.android])),
            ],
            // Android: Apple-only auth surfaces (passkeys, biometrics, Apple/web OAuth, DFP, captcha, keychain) are out.
            exclude: ProcessInfo.processInfo.environment["TARGET_OS_ANDROID"] != nil ? [
                "AppleOAuthClient",
                "CaptchaClient.swift",
                "DFPClient.swift",
                "KeychainClient/KeychainClientImplementation.swift",
                "KeychainClient/KeychainMigrations",
                "PasskeysClient",
                "StytchClient/Biometrics",
                "StytchClient/OAuth/OAuth+Apple.swift",
                "StytchClient/OAuth/OAuth+ThirdParty.swift",
                "StytchClient/Passkeys",
                "WebAuthenticationSessionClient",
                "Generated/StytchB2BClient.OAuth.ThirdParty.Discovery.start+AsyncVariants.generated.swift",
                "Generated/StytchB2BClient.OAuth.ThirdParty.start+AsyncVariants.generated.swift",
                "Generated/StytchB2BClient.SSO.OIDC.createConnection+AsyncVariants.generated.swift",
                "Generated/StytchB2BClient.SSO.OIDC.updateConnection+AsyncVariants.generated.swift",
                "Generated/StytchB2BClient.SSO.SAML.createConnection+AsyncVariants.generated.swift",
                "Generated/StytchB2BClient.SSO.SAML.deleteVerificationCertificate+AsyncVariants.generated.swift",
                "Generated/StytchB2BClient.SSO.SAML.updateConnection+AsyncVariants.generated.swift",
                "Generated/StytchB2BClient.SSO.SAML.updateConnectionByURL+AsyncVariants.generated.swift",
                "Generated/StytchB2BClient.SSO.authenticate+AsyncVariants.generated.swift",
                "Generated/StytchB2BClient.SSO.deleteConnection+AsyncVariants.generated.swift",
                "Generated/StytchB2BClient.SSO.discoverConnections+AsyncVariants.generated.swift",
                "Generated/StytchB2BClient.SSO.getConnections+AsyncVariants.generated.swift",
                "Generated/StytchB2BClient.SSO.start+AsyncVariants.generated.swift",
                "StytchB2BClient/StytchB2BClient+OAuth/StytchB2BClient+OAuth+ThirdParty+Discovery.swift",
                "StytchB2BClient/StytchB2BClient+OAuth/StytchB2BClient+OAuth+ThirdParty.swift",
                "StytchB2BClient/StytchB2BClient+SSO",
                "Generated/StytchClient.Biometrics.authenticate+AsyncVariants.generated.swift",
                "Generated/StytchClient.Biometrics.register+AsyncVariants.generated.swift",
                "Generated/StytchClient.Biometrics.removeRegistration+AsyncVariants.generated.swift",
                "Generated/StytchClient.OAuth.Apple.start+AsyncVariants.generated.swift",
                "Generated/StytchClient.OAuth.ThirdParty.start+AsyncVariants.generated.swift",
                "Generated/StytchClient.Passkeys.authenticate+AsyncVariants.generated.swift",
                "Generated/StytchClient.Passkeys.register+AsyncVariants.generated.swift",
                "Generated/StytchClient.Passkeys.update+AsyncVariants.generated.swift",
            ] : [],
            resources: [
                .process("PrivacyInfo.xcprivacy"),
            ]
        ),
        .testTarget(name: "StytchCoreTests", dependencies: ["StytchCore"]),
        .testTarget(name: "StytchUIUnitTests", dependencies: ["StytchCore", "StytchUI"]),
    ]
)
