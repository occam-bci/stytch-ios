# Gotchas

Hard-won pitfalls specific to consuming **this fork**. Point-in-time; verify against current source. No PR
mining was done (the fork has 0 merged first-party PRs) — these are derived from the fork delta and consumer usage.

# Concepts

* [encryption-key-rotation.md](encryption-key-rotation.md) - the keychain encryption-key race our one first-party commit fixes
* [branch-pin-drift.md](branch-pin-drift.md) - consumers pin a moving branch, not a release tag; the resolved revision drifts
