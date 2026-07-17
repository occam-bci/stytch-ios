# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository overview

`occam-bci/stytch-ios` is a **vendored fork** of the upstream Stytch iOS SDK
([stytchauth/stytch-ios](https://github.com/stytchauth/stytch-ios)). It ships two Swift Package Manager
products — `StytchCore` (headless auth API) and `StytchUI` (prebuilt UI) — consumed by the Atlas iOS apps.

**This fork carries a single first-party commit on top of upstream** (`ab363ff` — lazy keychain encryption-key
load) and exists only so `atlas-ios` / `atlas-lab-ios` can pin a branch that contains that fix. Treat the rest
of the SDK as upstream and out of scope: for internals, read the upstream source and its
[DocC reference](https://stytchauth.github.io/stytch-ios/main/StytchCore/documentation/stytchcore/).

## Why the fork exists (the delta)

- The pinned branch is **`fix/encryption_key_rotation_on_relaunch`** = `origin/main` (a mirror of upstream) +
  upstream-sync merges + one commit `ab363ff`.
- `ab363ff` makes the encryption key in `KeychainClientImplementation` **lazy** so it is created *after*
  `resetKeychainOnFreshInstall()` runs during `configure()` — fixing an encryption-key rotation on relaunch
  after reinstall.
- Full write-up, exact diff, and how to re-derive the delta:
  [`.knowledge/architecture/fork-delta.md`](.knowledge/architecture/fork-delta.md).

## How Atlas consumes it

- **atlas-ios** imports `StytchCore`; **atlas-lab-ios** imports `StytchCore` + `StytchUI`.
- Apps only **drive** the SDK — auth business logic lives **server-side** (auth-proxy + Stytch). Do not add
  client-side auth logic here or in the apps.
- Native Sign in with Apple runs through this SDK; environment/label subtleties are in
  [`.knowledge/integrations/apple-signin.md`](.knowledge/integrations/apple-signin.md).

## Fork workflow (read before changing anything)

1. **Keep the delta minimal.** First-party changes go on the pinned branch on top of upstream; do not refactor
   upstream code. Every added commit widens the merge surface for future upstream syncs.
2. **Upstream-sync** by merging `upstream/main` into the pinned branch, keeping `ab363ff` on top. Re-verify with
   `git log --oneline upstream/main..origin/fix/encryption_key_rotation_on_relaunch`.
3. **Consumers pin a branch, not a tag** — the resolved revision drifts on every push. Confirm the pinned commit
   in each app's `Package.resolved`. See [`.knowledge/gotchas/branch-pin-drift.md`](.knowledge/gotchas/branch-pin-drift.md).
4. **Exit criterion:** once upstream ships an equivalent fix, migrate consumers to a tagged release and retire
   the branch pin.

## Common commands

Driven by the [`Makefile`](Makefile) (tooling via `mint` / `bundle`):

- `make setup` / `make tools` — install toolchain (`brew bundle`, `mint bootstrap`).
- `make codegen` — regenerate Sourcery `+AsyncVariants` into `Sources/`. **Never hand-edit generated files.**
- `make test` (macOS) · `make test-ios` · `make test-tvos` · `make test-watchos` · `make test-all`.
- `make lint` — `swiftlint --strict` + `swiftformat --lint`; `make format` — apply SwiftFormat.
- `make docs` / `make docs-site` — DocC build.

CI, versioning (`cut_version`), and the sync model: [`.knowledge/build/ci-and-release.md`](.knowledge/build/ci-and-release.md).

## Code style

Defer to upstream's committed config — [`.swiftformat`](.swiftformat) and [`.swiftlint.yml`](.swiftlint.yml).
Keep changes **surgical**: match surrounding style, do not reformat untouched upstream code, and do not
introduce first-party stylistic drift that will conflict on the next upstream merge.

## Pull requests

- The PR template is at **repo root** (`pull_request_template.md`), not under `.github/`. Fill in Changes +
  Checklist.
- `.github/CODEOWNERS` still points at upstream (`@stytchauth/engineering`) — verify occam-bci review routing.

## Knowledge catalog

This repo ships an [OKF](https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md)
knowledge catalog at [`.knowledge/`](.knowledge/index.md) — a browsable, cross-linked markdown tree **scoped to
our fork delta**, not the whole SDK.

- **Read it first** when working the fork — start at [`.knowledge/index.md`](.knowledge/index.md), then
  [`.knowledge/architecture/fork-delta.md`](.knowledge/architecture/fork-delta.md).
- **Keep it fresh** — when the delta or a consumer fact changes, update the relevant concept and append a dated
  entry to [`.knowledge/log.md`](.knowledge/log.md).
- **Point-in-time** — concepts carry a `timestamp`; verify `file:line` and the delta against current source.
- **vs `MEMORY.md`** — `MEMORY.md` holds quick durable notes; `.knowledge/` is the structured catalog.

## Imported libraries — where to find them

**None — leaf library.** This fork imports **no** first-party occam-bci libraries; its only dependencies are
third-party SPM packages (`PhoneNumberKit`, `recaptcha-enterprise-mobile-sdk`, `SwiftyJSON`, `stytch-ios-dfp`)
declared in [`Package.swift`](Package.swift).
