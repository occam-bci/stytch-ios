# stytch-ios knowledge catalog — update log

## 2026-07-21

* **Philosophy shift — abstract the `api/` concepts** (review feedback on occam-logger PR #6, applied effort-wide): the API docs duplicated the source (signature/default tables, `file:line` ranges) and would have required upkeep on every code change. Rewrote [api/public-surface.md](api/public-surface.md) to the what / why / where-to-look level; converted line-range citations to `file` + symbol across the catalog. Other content untouched. Principle now stated in [index.md](index.md).

## 2026-07-17

* **Initialization**: Seeded the OKF bundle for this vendored fork. Scoped deliberately to OUR delta — the
  single first-party commit `ab363ff` (lazy keychain encryption-key load) — plus fork workflow, public-surface
  pointer, build/release, and how the Atlas apps consume it. Sources: `README.md`, `Package.swift`, `Makefile`,
  `.github/workflows/`, the `fix/encryption_key_rotation_on_relaunch` branch (`git log upstream/main..origin/…`),
  and saved Apple-sign-in / auth-architecture memories. No PR mining (0 merged first-party PRs). Upstream SDK
  internals are intentionally left undocumented — see [architecture/fork-delta.md](architecture/fork-delta.md).
