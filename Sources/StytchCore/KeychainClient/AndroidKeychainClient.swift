#if os(Android)
  import Crypto
  import Foundation

  // Android stand-in for the iOS Keychain. Items live in one JSON file in the app's private storage, written
  // atomically with owner-only permissions; Android's per-app sandbox is the only protection. The encryption key
  // StytchCore uses for its UserDefaults session cache sits in the same sandbox, so this is not hardware-backed:
  // production needs the key in Android Keystore (via a Kotlin bridge), which this does not provide.
  final class AndroidKeychainClient: KeychainClient {
    static let shared = AndroidKeychainClient()

    private struct StoredItem: Codable {
      let data: Data
      let account: String?
      let label: String?
      let generic: Data?
      let createdAt: Date
      var modifiedAt: Date
    }

    private let lock = NSLock()
    private let fileURL: URL
    private var items: [String: [StoredItem]]
    private var cachedEncryptionKey: SymmetricKey?

    private init() {
      let directory = (try? FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true))
        ?? URL(fileURLWithPath: NSTemporaryDirectory())
      self.fileURL = directory.appendingPathComponent("stytch-keychain.json")
      self.items = (try? Data(contentsOf: self.fileURL)).flatMap { try? JSONDecoder().decode([String: [StoredItem]].self, from: $0) } ?? [:]
    }

    var encryptionKey: SymmetricKey? {
      self.lock.lock()
      defer { self.lock.unlock() }
      if let cachedEncryptionKey { return cachedEncryptionKey }
      let name = KeychainItem.encryptionKey.name
      let key: SymmetricKey
      if let stored = self.items[name]?.first {
        key = SymmetricKey(data: stored.data)
      } else {
        key = SymmetricKey(size: .bits256)
        let now = Date()
        let data = key.withUnsafeBytes { Data($0) }
        self.items[name] = [StoredItem(data: data, account: "EncryptedUserDefaultsKey", label: nil, generic: nil, createdAt: now, modifiedAt: now)]
        self.persistLocked()
      }
      self.cachedEncryptionKey = key
      return key
    }

    func getQueryResults(item: KeychainItem) throws -> [KeychainQueryResult] {
      self.lock.lock()
      defer { self.lock.unlock() }
      return (self.items[item.name] ?? []).map {
        KeychainQueryResult(data: $0.data, createdAt: $0.createdAt, modifiedAt: $0.modifiedAt, label: $0.label, account: $0.account, generic: $0.generic)
      }
    }

    func valueExistsForItem(item: KeychainItem) -> Bool {
      self.lock.lock()
      defer { self.lock.unlock() }
      return !(self.items[item.name] ?? []).isEmpty
    }

    func setValueForItem(value: KeychainItem.Value, item: KeychainItem) throws {
      self.lock.lock()
      defer { self.lock.unlock() }
      var stored = self.items[item.name] ?? []
      let now = Date()
      if let index = stored.firstIndex(where: { $0.account == value.account }) {
        let createdAt = stored[index].createdAt
        stored[index] = StoredItem(data: value.data, account: value.account, label: value.label, generic: value.generic, createdAt: createdAt, modifiedAt: now)
      } else {
        stored.append(StoredItem(data: value.data, account: value.account, label: value.label, generic: value.generic, createdAt: now, modifiedAt: now))
      }
      self.items[item.name] = stored
      self.persistLocked()
    }

    func removeItem(item: KeychainItem) throws {
      self.lock.lock()
      defer { self.lock.unlock() }
      self.items[item.name] = nil
      if item.name == KeychainItem.encryptionKey.name { self.cachedEncryptionKey = nil }
      self.persistLocked()
    }

    private func persistLocked() {
      guard let data = try? JSONEncoder().encode(self.items) else { return }
      try? data.write(to: self.fileURL, options: .atomic)
      try? FileManager.default.setAttributes([.posixPermissions: 0o600], ofItemAtPath: self.fileURL.path)
    }
  }
#endif
