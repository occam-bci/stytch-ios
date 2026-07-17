---
type: Gotcha
title: Keychain encryption-key rotates on relaunch (fresh-install reset race)
description: Eager key load in the keychain singleton's init created the key before the fresh-install keychain reset wiped it; the fix is lazy loading (our only fork commit).
resource: https://github.com/occam-bci/stytch-ios/commit/ab363ffb48a690083bbad077769f9fd59aef80c8
tags: [keychain, encryption-key, fresh-install, race, fork-delta]
timestamp: 2026-07-17T00:00:00Z
---

# Symptom

After deleting and reinstalling the app (iOS keychain items survive reinstall; UserDefaults does not), the
Stytch encryption key appears to **rotate on relaunch** — decrypting previously stored encrypted values fails,
because the in-memory key no longer matches what is in the keychain.

# Cause

`KeychainClientImplementation.shared` (a singleton) eagerly called `loadEncryptionKey()` from its `private init()`,
and `getEncryptionKey()` **creates** the key if absent. That creation could happen **before**
`StytchClient.configure(...)` ran `resetKeychainOnFreshInstall()`, which deletes all keychain items on a fresh
install ([`StytchClientCommon.swift:103-113`](../../Sources/StytchCore/StytchClientCommon.swift)). The reset then
wiped the just-created key while an in-memory copy lingered → memory/keychain divergence on relaunch.

# Fix

Commit [ab363ff](https://github.com/occam-bci/stytch-ios/commit/ab363ffb48a690083bbad077769f9fd59aef80c8) —
the **only first-party commit in this fork**. It removes the eager `loadEncryptionKey()` from `init()` and makes
`encryptionKey` a lazy computed property (cached into `cachedEncryptionKey` on first access), so the key is only
created **after** the fresh-install reset. Consumers get it by pinning `fix/encryption_key_rotation_on_relaunch`.

# See also

- [../architecture/fork-delta.md](../architecture/fork-delta.md) — full mechanism, exact diff, and how to re-derive the delta.
- [branch-pin-drift.md](branch-pin-drift.md) — how consumers actually pull this fix in.

# Citations

[1] [`Sources/StytchCore/KeychainClient/KeychainClientImplementation.swift`](../../Sources/StytchCore/KeychainClient/KeychainClientImplementation.swift).
[2] [`Sources/StytchCore/StytchClientCommon.swift:103-113`](../../Sources/StytchCore/StytchClientCommon.swift) — `resetKeychainOnFreshInstall()`.
