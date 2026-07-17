# stytch-ios knowledge catalog — update log

## 2026-07-17

* **Initialization**: Seeded the OKF bundle for this vendored fork. Scoped deliberately to OUR delta — the
  single first-party commit `ab363ff` (lazy keychain encryption-key load) — plus fork workflow, public-surface
  pointer, build/release, and how the Atlas apps consume it. Sources: `README.md`, `Package.swift`, `Makefile`,
  `.github/workflows/`, the `fix/encryption_key_rotation_on_relaunch` branch (`git log upstream/main..origin/…`),
  and saved Apple-sign-in / auth-architecture memories. No PR mining (0 merged first-party PRs). Upstream SDK
  internals are intentionally left undocumented — see [architecture/fork-delta.md](architecture/fork-delta.md).
