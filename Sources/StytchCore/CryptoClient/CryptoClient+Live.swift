#if canImport(CryptoKit)
#if canImport(CryptoKit)
import CryptoKit
#else
import Crypto
#endif
#else
import Crypto
#endif
import Foundation

extension CryptoClient {
    static let live: Self = .init { value in
        .init(SHA256.hash(data: value))
    } dataWithRandomBytesOfCount: { byteCount in
        var buffer = [UInt8](repeating: 0, count: Int(byteCount))

        #if os(Android)
        // SystemRandomNumberGenerator is the kernel CSPRNG (getrandom) on Android.
        var generator = SystemRandomNumberGenerator()
        for index in buffer.indices { buffer[index] = generator.next() }
        #else
        guard SecRandomCopyBytes(kSecRandomDefault, buffer.count, &buffer) == errSecSuccess else {
            throw StytchSDKError.randomNumberGenerationFailed
        }
        #endif

        return .init(buffer)
    } generateKeyPair: {
        let privateKey = Curve25519.Signing.PrivateKey()
        return (
            privateKey.rawRepresentation,
            privateKey.publicKey.rawRepresentation
        )
    } publicKeyForPrivateKey: { privateKeyData in
        try Curve25519.Signing.PrivateKey(rawRepresentation: privateKeyData)
            .publicKey
            .rawRepresentation
    } signChallengeWithPrivateKey: { challenge, privateKeyData in
        try Curve25519.Signing.PrivateKey(rawRepresentation: privateKeyData)
            .signature(for: challenge)
    }
}
