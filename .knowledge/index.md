---
okf_version: "0.1"
---

# stytch-ios knowledge catalog

`occam-bci/stytch-ios` is a **vendored fork** of the upstream Stytch iOS SDK
([stytchauth/stytch-ios](https://github.com/stytchauth/stytch-ios)). It ships `StytchCore` (headless auth API) and
`StytchUI` (prebuilt UI) as Swift Package Manager products. The Atlas iOS apps drive this SDK; the auth business
logic itself lives server-side (auth-proxy + Stytch), not in the client.

**This catalog is scoped to OUR delta, not the whole SDK.** The fork carries a **single first-party commit** on
top of upstream — a keychain encryption-key fix — and exists only so `atlas-ios` / `atlas-lab-ios` can pin it.
Everything else is upstream and **out of scope** here: for SDK internals, read the upstream source and the
[upstream DocC](https://stytchauth.github.io/stytch-ios/main/StytchCore/documentation/stytchcore/). Start with
[architecture/fork-delta.md](architecture/fork-delta.md) — it is the reason this repo exists.

This directory is an [Open Knowledge Format](https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md)
(OKF) v0.1 bundle: a tree of markdown concept files. Read it before touching the fork, then jump to source. For
conventions, commands, and the fork workflow see [../CLAUDE.md](../CLAUDE.md).

> **Point-in-time knowledge.** Each concept reflects what was true when written (see its `timestamp`). Verify
> `file:line` citations and the fork delta against current source (`git log upstream/main..origin/HEAD`) before
> acting; when a note conflicts with the code, trust the code and update the note.

# Architecture

* [architecture/](architecture/) - why the fork exists, the exact upstream delta, the keychain-client mechanism it changes

# Public API

* [api/](api/) - the public surface (`StytchCore` / `StytchUI` products, clients, generated concurrency variants) — mostly upstream

# Build & release

* [build/](build/) - Makefile targets, CI workflows, Sourcery codegen, the `cut_version` release model, upstream-sync

# Gotchas

* [gotchas/](gotchas/) - branch-pin drift, and the encryption-key race our delta fixes

# Integrations

* [integrations/](integrations/) - how the Atlas apps consume this fork; native Sign in with Apple via Stytch
