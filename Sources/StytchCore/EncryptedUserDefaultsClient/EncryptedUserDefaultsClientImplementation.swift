#if canImport(CryptoKit)
import CryptoKit
#else
import Crypto
#endif
import Foundation

final class EncryptedUserDefaultsClientImplementation: EncryptedUserDefaultsClient {
    static let shared = EncryptedUserDefaultsClientImplementation()
    @Dependency(\.keychainClient) private var keychainClient
    private let queue: DispatchQueue
    private let queueKey = DispatchSpecificKey<Void>()

    private var isOnQueue: Bool {
        DispatchQueue.getSpecific(key: queueKey) != nil
    }

    #if os(Android)
    internal let defaults = AndroidFileDefaults(name: "stytch-encrypted-defaults.json")
    #else
    internal let defaults: UserDefaults = .init(suiteName: "StytchEncryptedUserDefaults") ?? .standard
    #endif

    private init() {
        queue = DispatchQueue(label: "StytchEncryptedUserDefaultsClientQueue")
        queue.setSpecific(key: queueKey, value: ())
    }

    private func safelyEnqueue<T>(_ block: () throws -> T) throws -> T {
        if isOnQueue {
            return try block()
        } else {
            return try queue.sync { try block() }
        }
    }

    func getItem(item: EncryptedUserDefaultsItem) throws -> EncryptedUserDefaultsItemResult? {
        try safelyEnqueue {
            guard let userDefaultsData = defaults.data(forKey: item.name) else {
                throw EncryptedUserDefaultsError.noDataFound
            }
            guard let decrypted = try decryptData(encryptedData: userDefaultsData) else {
                throw EncryptedUserDefaultsError.decryptedDataWasNil
            }
            guard let data = decrypted.data(using: .utf8) else {
                throw EncryptedUserDefaultsError.decryptedDataCouldNotBeStringified
            }
            return .init(data: data)
        }
    }

    func itemExists(item: EncryptedUserDefaultsItem) -> Bool {
        let result = try? safelyEnqueue {
            let encryptedData = defaults.data(forKey: item.name)
            return encryptedData != nil
        }
        return result ?? false
    }

    func setValueForItem(value: String?, item: EncryptedUserDefaultsItem) throws {
        try safelyEnqueue {
            guard let valueString = value else {
                return removeItem(item: item)
            }
            let encryptedText = try encryptString(plainText: valueString)
            defaults.set(encryptedText, forKey: item.name)
            let encryptedDate = try encryptString(plainText: Date().asJson(encoder: Current.jsonEncoder))
            defaults.set(encryptedDate, forKey: EncryptedUserDefaultsItem.lastValidatedAtDate(item.name).name)
        }
    }

    func removeItem(item: EncryptedUserDefaultsItem) {
        try? safelyEnqueue {
            defaults.removeObject(forKey: item.name)
            defaults.removeObject(forKey: EncryptedUserDefaultsItem.lastValidatedAtDate(item.name).name)
        }
    }

    private func encryptString(plainText: String) throws -> Data? {
        try safelyEnqueue {
            guard let encryptionKey = keychainClient.encryptionKey else {
                throw EncryptedUserDefaultsError.encryptionKeyNotAvailable
            }
            let sealedBox = try AES.GCM.seal(
                Data(plainText.utf8),
                using: encryptionKey
            )
            return sealedBox.combined
        }
    }

    private func decryptData(encryptedData: Data) throws -> String? {
        try safelyEnqueue {
            guard let encryptionKey = keychainClient.encryptionKey else {
                throw EncryptedUserDefaultsError.encryptionKeyNotAvailable
            }
            do {
                let sealedBox = try AES.GCM.SealedBox(combined: encryptedData)
                let decryptedData = try AES.GCM.open(sealedBox, using: encryptionKey)
                return String(data: decryptedData, encoding: .utf8)
            } catch {
                throw EncryptedUserDefaultsError.dataCouldNotBeDecrypted
            }
        }
    }
}

#if os(Android)
// corelibs UserDefaults does not persist on Android; only ever touched from the client's serial queue.
final class AndroidFileDefaults {
    private let fileURL: URL
    private var values: [String: Data]

    init(name: String) {
        let directory = (try? FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true))
            ?? URL(fileURLWithPath: NSTemporaryDirectory())
        fileURL = directory.appendingPathComponent(name)
        values = (try? Data(contentsOf: fileURL)).flatMap { try? JSONDecoder().decode([String: Data].self, from: $0) } ?? [:]
    }

    func data(forKey key: String) -> Data? { values[key] }

    func set(_ value: Data?, forKey key: String) {
        values[key] = value
        persist()
    }

    func removeObject(forKey key: String) {
        values[key] = nil
        persist()
    }

    private func persist() {
        try? JSONEncoder().encode(values).write(to: fileURL, options: .atomic)
        try? FileManager.default.setAttributes([.posixPermissions: 0o600], ofItemAtPath: fileURL.path)
    }
}
#endif
