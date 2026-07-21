---
type: Architecture
title: The fork delta — why occam-bci/stytch-ios exists
description: Our fork carries a single first-party commit (lazy keychain encryption-key load) on top of upstream; everything else mirrors stytchauth/stytch-ios.
resource: https://github.com/occam-bci/stytch-ios/commit/ab363ffb48a690083bbad077769f9fd59aef80c8
tags: [fork, delta, keychain, encryption-key, upstream-sync]
timestamp: 2026-07-17T00:00:00Z
---

`occam-bci/stytch-ios` is a **vendored fork** of `stytchauth/stytch-ios`. It exists for exactly **one** reason:
to carry a keychain encryption-key fix that upstream had not shipped, so `atlas-ios` / `atlas-lab-ios` can pin a
branch that contains it. Do **not** treat this repo as a place to modify the SDK — keep the delta minimal.

# The exact delta

As of writing, the fork's only first-party change is **one commit**:

```
git remote -v
  origin    git@github.com:occam-bci/stytch-ios.git
  upstream  git@github.com:stytchauth/stytch-ios.git

git log --oneline upstream/main..origin/fix/encryption_key_rotation_on_relaunch
  ab363ff  Lazily load encryption key to avoid fresh-install reset race   ← the ONLY first-party commit
  2235d4e  Merge branch 'stytchauth:main' into fix/encryption_key_rotation_on_relaunch
```

- `origin/main` is a (slightly stale) mirror of `upstream/main` with **zero** first-party commits ahead
  (`git rev-list --count upstream/main..origin/main == 0`).
- The consumer-pinned branch **`fix/encryption_key_rotation_on_relaunch`** = `origin/main` + a merge of newer
  upstream (bringing in upstream PRs #599/#600) + the single commit `ab363ff`.
- `2235d4e` is just an upstream-sync merge; `ab363ff` is the real change. Everything else is upstream.

> If a future reader finds more than this one commit ahead of upstream, the fork has grown — re-derive the delta
> with the `git log upstream/main..origin/<pinned-branch>` command above and update this concept.

# What ab363ff changes

One file: [`Sources/StytchCore/KeychainClient/KeychainClientImplementation.swift`](../../Sources/StytchCore/KeychainClient/KeychainClientImplementation.swift)
(+11 / −3). It makes the singleton's encryption key **lazy** instead of eager:

- **Before:** `private init()` eagerly called `loadEncryptionKey()`, and `var encryptionKey: SymmetricKey?` was a
  plain stored property populated at construction.
- **After:** the eager `loadEncryptionKey()` call is removed from `init()`; `encryptionKey` becomes a **computed
  property** that lazily loads and caches into a private `cachedEncryptionKey` on first access.

# The race it fixes

`KeychainClientImplementation.shared` is a singleton. `getEncryptionKey()` **creates** a 256-bit key in the
keychain if none exists. iOS keychain items **survive app deletion/reinstall**, so the SDK purges leftovers on a
fresh install: `StytchClient.configure(...)` → `resetKeychainOnFreshInstall()`, which deletes all keychain items
when the `stytch_install_id_defaults_key` UserDefaults marker is absent
([`Sources/StytchCore/StytchClientCommon.swift`](../../Sources/StytchCore/StytchClientCommon.swift), `resetKeychainOnFreshInstall`).

The bug: eagerly loading the key in the singleton's `init` could **create the encryption key before**
`resetKeychainOnFreshInstall()` ran during `configure()`. The reset then wiped the just-created key while an
in-memory copy lingered, so the app relaunched with an encryption key that no longer matched keychain state —
the "encryption-key rotation on relaunch" the branch name refers to. Deferring the load until first use
guarantees the key is created **after** the fresh-install reset, keeping memory and keychain consistent.

# See also

- [../gotchas/encryption-key-rotation.md](../gotchas/encryption-key-rotation.md) — the same fix framed symptom→cause→fix
- [../gotchas/branch-pin-drift.md](../gotchas/branch-pin-drift.md) — consumers pin this branch, not a release
- [../build/ci-and-release.md](../build/ci-and-release.md) — how upstream-sync + versioning work

# Citations

[1] [`Sources/StytchCore/KeychainClient/KeychainClientImplementation.swift`](../../Sources/StytchCore/KeychainClient/KeychainClientImplementation.swift) (`encryptionKey`, `init`, `loadEncryptionKey`, `getEncryptionKey`).
[2] [`Sources/StytchCore/StytchClientCommon.swift`](../../Sources/StytchCore/StytchClientCommon.swift) (`resetKeychainOnFreshInstall`, `configure`).
[3] Commit [ab363ff](https://github.com/occam-bci/stytch-ios/commit/ab363ffb48a690083bbad077769f9fd59aef80c8) (branch `fix/encryption_key_rotation_on_relaunch`).
