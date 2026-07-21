# Copilot Instructions

**This repository is a vendored fork** of the upstream Stytch iOS SDK
([stytchauth/stytch-ios](https://github.com/stytchauth/stytch-ios)). It carries a **single first-party commit**
(`ab363ff` — lazy keychain encryption-key load) so the Atlas apps can pin a branch containing that fix.

**Review OUR delta, not upstream code.** Focus comments on first-party changes on top of upstream — the diff
vs `upstream/main`. Do **not** flag pre-existing upstream style, naming, or design as if it were new; upstream
code is out of scope and reformatting it only widens future merge conflicts. Consult the
[`.knowledge/`](../.knowledge/index.md) catalog (start at
[`architecture/fork-delta.md`](../.knowledge/architecture/fork-delta.md)) for context, and keep comments
**surgical** — flag issues and suggest minimal fixes; never propose large refactors.

## Review priorities

In order:

1. **Security** — flag any committed password, credential, API key, token, or `.env` / secrets file in the
   diff; safe handling of keychain, tokens, and encryption material; no force-unwrap (`!`, `try!`) on external
   or untrusted input. Extra scrutiny on anything touching `KeychainClient` — the encryption-key path is exactly
   what this fork changes.
2. **Public-API stability & duplication** — flag breaking changes to the public surface (`StytchCore` /
   `StytchUI` products, `StytchClient` / `StytchUIClient` entry points) consumed by `atlas-ios` /
   `atlas-lab-ios`; prefer reusing existing helpers over reinventing.
3. **Correctness / UX of public behavior** — auth and keychain paths must fail safely; no half-wired or
   placeholder behavior merged.

## Tests

New first-party logic must be covered by unit tests (`StytchCoreTests` / `StytchUIUnitTests`) — flag untested
new logic. Keep coverage sustainable — do not add sprawling tests for untouched upstream code.

## Generated & build hygiene

- Never hand-edit the Sourcery-generated `+AsyncVariants` files under `Sources/StytchCore/Generated/` —
  regenerate with `make codegen`.
- Do not reformat untouched upstream code; match the committed `.swiftformat` / `.swiftlint.yml`.

## Release discipline

The fork inherits upstream's `cut_version` tag flow, but **consumers pin the branch, not a tag** — there is no
semver signal for first-party changes. After a meaningful change to the pinned branch, note it (a short
changelog to `#ios-dev`) and update [`.knowledge/log.md`](../.knowledge/log.md), so consumers know their
resolved revision moved. See [`.knowledge/gotchas/branch-pin-drift.md`](../.knowledge/gotchas/branch-pin-drift.md).

## Also enforce

- **Comments stay small and surgical.** Rationale and context belong in the OKF `.knowledge/` catalog, not in verbose inline comments.
- **Large changes need an OKF note.** A substantial change or tricky fix must add or adjust a `.knowledge/` concept (and a `log.md` entry) that explains it — flag large PRs that don't.
