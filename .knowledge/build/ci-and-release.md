---
type: Playbook
title: Build, test, codegen, and the upstream-sync model
description: Makefile targets, the inherited CI workflows, Sourcery codegen, cut_version versioning, and how to keep the fork synced with upstream.
resource: https://github.com/occam-bci/stytch-ios/tree/main/.github/workflows
tags: [build, ci, makefile, sourcery, versioning, upstream-sync]
timestamp: 2026-07-17T00:00:00Z
---

# Local build & test

Driven by the [`Makefile`](../../Makefile) (SPM project generated into `Stytch/Stytch.xcodeproj`; tooling via
`mint` / `bundle`):

- `make setup` / `make tools` — Homebrew bundle + `mint bootstrap`.
- `make codegen` — **Sourcery** regenerates the `+AsyncVariants` concurrency wrappers into `Sources/` (templates
  in `Resources/Sourcery/Templates`). Every `test*`/`docs` target depends on it. Never hand-edit generated files.
- `make test` (macOS), `make test-ios`, `make test-tvos`, `make test-watchos`, `make test-all` — run the
  `StytchCoreTests` and `StytchUIUnitTests` schemes across platforms (iOS sim pinned to iPhone 16 Pro / OS 18.5).
- `make lint` — `swiftlint --strict` + `swiftformat --lint`; `make format` — apply SwiftFormat.
- `make docs` / `make docs-site` — DocC build for `StytchCore` + `StytchUI`.

# CI workflows

Inherited from upstream, in [`.github/workflows/`](../../.github/workflows/):

| Workflow | Purpose |
|---|---|
| `test.yml` | Build + unit tests |
| `codeql.yml` | CodeQL advanced security scan |
| `cut_version.yml` | Manual (`workflow_dispatch`) version bump → tag → auto-merge PR |
| `release.yml` | Create a GitHub release |
| `docs.yml` | Publish DocC site |

`CODEOWNERS` still points at `@stytchauth/engineering` (upstream) — verify occam-bci review routing rather than
assuming CODEOWNERS applies. The PR template lives at **repo root** (`pull_request_template.md`), not in `.github/`.

# Versioning

The SDK version is a **generated Swift constant** — `Version.current` in
[`Sources/StytchCore/SharedModels/ClientInfo+Version.swift`](../../Sources/StytchCore/SharedModels/) — bumped by
`cut_version.yml` (which tags `X.Y.Z` and opens an auto-merge PR). Git tags (`X.Y.Z`) mark releases.
**Atlas consumers do not pin a tag** — they pin the fix branch; see [../gotchas/branch-pin-drift.md](../gotchas/branch-pin-drift.md).

# Keeping the fork synced

The fork tracks two remotes (`origin` = occam-bci, `upstream` = stytchauth). To refresh:

1. Merge `upstream/main` into the pinned branch (`fix/encryption_key_rotation_on_relaunch`), keeping the single
   first-party commit `ab363ff` on top — exactly the shape described in [../architecture/fork-delta.md](../architecture/fork-delta.md).
2. Re-verify the delta is still just that one commit: `git log --oneline upstream/main..origin/<pinned-branch>`.
3. Bump the consumer pins only if the resolved revision must move (the branch pin auto-drifts otherwise).

# Citations

[1] [`Makefile`](../../Makefile); [`.github/workflows/`](../../.github/workflows/); [`.github/CODEOWNERS`](../../.github/CODEOWNERS).
[2] [`cut_version.yml`](../../.github/workflows/cut_version.yml) — tag + auto-merge version PR; commits `ClientInfo+Version.swift`.
[3] [`Stytch.podspec`](../../Stytch.podspec) — `version` resolved from `Scripts/version show-current`.
