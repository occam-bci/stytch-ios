# MEMORY

Durable, non-obvious gotchas for this repo. Prefer a note here over a long inline comment.

> **Knowledge catalog.** Structured, browsable knowledge (the fork delta, public surface, build/release,
> gotchas, consumer integration) lives in the OKF bundle at [`.knowledge/`](.knowledge/index.md), scoped to our
> fork delta rather than the whole SDK. This `MEMORY.md` stays the place for quick durable notes; deep dives
> graduate into a `.knowledge/` concept (and get an entry in [`.knowledge/log.md`](.knowledge/log.md)).

## This is a vendored fork — keep the delta tiny

`occam-bci/stytch-ios` forks `stytchauth/stytch-ios`. The fork's **only first-party commit** is `ab363ff`
("Lazily load encryption key to avoid fresh-install reset race"). `origin/main` is a mirror of `upstream/main`
with zero commits ahead. Two remotes: `origin` (occam-bci), `upstream` (stytchauth). Re-derive the delta any
time with `git log --oneline upstream/main..origin/fix/encryption_key_rotation_on_relaunch`. Do **not** refactor
upstream code — every first-party commit widens the merge surface.

## The encryption-key fix (`ab363ff`)

`KeychainClientImplementation` used to eagerly `loadEncryptionKey()` in `init()`, which could create the key
*before* `resetKeychainOnFreshInstall()` wiped the keychain during `configure()` — so the key rotated on
relaunch after reinstall. The fix makes `encryptionKey` a lazy computed property (cached on first use). Full
mechanism: [`.knowledge/architecture/fork-delta.md`](.knowledge/architecture/fork-delta.md).

## Consumers pin a branch, not a tag

atlas-ios / atlas-lab-ios pin branch `fix/encryption_key_rotation_on_relaunch`. The resolved SPM revision drifts
on every push (no semver, no changelog) — check each app's `Package.resolved`, not just the branch name. Exit
plan: migrate to a tagged release once upstream ships an equivalent fix.
[`.knowledge/gotchas/branch-pin-drift.md`](.knowledge/gotchas/branch-pin-drift.md).

## Sign in with Apple (consumer-side, but SDK-provided)

Native SIWA via Stytch (Apple team `5N3X2A262P`, two Stytch envs). **Staging SIWA is unsupported** — a staging
failure is not a regression. The `"oauth2"` string in Apple ID settings is a **frozen per-`sub` label** Apple
sets at first sign-in, not a live identifier — never key logic off it. Domain changes are add-before-remove.
[`.knowledge/integrations/apple-signin.md`](.knowledge/integrations/apple-signin.md).

## Build gotchas

- `make codegen` (Sourcery) generates the `+AsyncVariants` files into `Sources/StytchCore/Generated/` — **never
  hand-edit them**; regenerate.
- The SDK version is a generated constant (`Version.current` in `ClientInfo+Version.swift`), bumped by
  `cut_version.yml`. The PR template is at repo root, not `.github/`. `.github/CODEOWNERS` still points upstream.
