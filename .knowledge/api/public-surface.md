---
type: Module
title: Public surface — StytchCore & StytchUI
description: The two SPM products the fork ships, their client entry points, and the Sourcery-generated concurrency variants. Mostly upstream.
resource: https://stytchauth.github.io/stytch-ios/main/StytchCore/documentation/stytchcore/
tags: [api, spm, stytchcore, stytchui, public-surface, upstream]
timestamp: 2026-07-21T00:00:00Z
---

The fork ships two SPM products, declared in [`Package.swift`](../../Package.swift): **`StytchCore`**, the
headless auth API for client-managed flows (imported by both atlas-ios and atlas-lab-ios), and **`StytchUI`**,
a prebuilt, configurable auth UI layered on top of `StytchCore` (imported by atlas-lab-ios only). For the
current product/target declarations, read `Package.swift` in the source.

# Entry points

- **Consumer:** `StytchClient` (headless) / `StytchUIClient` (prebuilt UI). Configure once via
  `StytchClient.configure(configuration:)`; readiness is published through `isInitialized`.
- **B2B:** `StytchB2BClient` / `StytchB2BUIClient` — **not used by Atlas** (consumer project).
- Auth methods are namespaced by type (e.g. `StytchClient.otps`, `.passwords`, `.sessions`, `.oauth`). Atlas
  drives password + email-OTP and native Sign in with Apple — see [../integrations/atlas-consumers.md](../integrations/atlas-consumers.md).

# Generated concurrency variants

`StytchCore` is authored in `async/await`; Sourcery generates `Combine` and completion-handler variants into
[`Sources/StytchCore/Generated/`](../../Sources/StytchCore/Generated/) (files ending `+AsyncVariants`). **Do not
hand-edit generated files** — they are re-produced by `make codegen` (see [../build/ci-and-release.md](../build/ci-and-release.md)).

# Scope

Beyond the entry points above, the method-level API is upstream and documented in the
[upstream DocC](https://stytchauth.github.io/stytch-ios/main/StytchCore/documentation/stytchcore/) and the
[`READMEs/`](../../READMEs/) guides (Deeplinks, EmailMagicLinks, OAuth, Passwords, Sessions, UI). This catalog
does not duplicate them.

# Citations

[1] [`Package.swift`](../../Package.swift) — product/target declarations.
[2] [`README.md`](../../README.md) — integration options, concurrency variants (Sourcery), further-reading links.
