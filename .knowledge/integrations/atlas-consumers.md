---
type: Integration
title: How the Atlas apps consume this fork
description: atlas-ios and atlas-lab-ios import StytchCore (and StytchUI in lab-ios) and drive the SDK; auth business logic lives server-side in the auth-proxy + Stytch.
resource: https://github.com/occam-bci/atlas-ios
tags: [atlas-ios, atlas-lab-ios, consumers, auth-proxy, integration]
timestamp: 2026-07-17T00:00:00Z
---

# Consumers

| App | Imports | Notes |
|---|---|---|
| [atlas-ios](https://github.com/occam-bci/atlas-ios) | `StytchCore` | Consumer app — password + email-OTP + native Sign in with Apple. |
| [atlas-lab-ios](https://github.com/occam-bci/atlas-lab-ios) | `StytchCore`, `StytchUI` | Lab app — also uses the prebuilt `StytchUI` layer. |

Both pin the fork by **branch** `fix/encryption_key_rotation_on_relaunch` (see
[../gotchas/branch-pin-drift.md](../gotchas/branch-pin-drift.md)). This fork is a **leaf** — it imports no
first-party occam-bci libraries, only third-party SPM deps (`PhoneNumberKit`, `recaptcha-enterprise-mobile-sdk`,
`SwiftyJSON`, `stytch-ios-dfp`) per [`Package.swift`](../../Package.swift).

# Where auth logic lives

The apps only **drive** the SDK; the auth business logic is **server-side** (the Atlas **auth-proxy** + Stytch).
`atlas-backend` / `atlas-internal-backend` hold no auth logic. Do not push auth decisions client-side — the SDK
call sites in the apps are thin wrappers around Stytch flows.

- atlas-ios wiring: [github.com/occam-bci/atlas-ios/…/.knowledge/subsystems/auth.md](https://github.com/occam-bci/atlas-ios/blob/dev/.knowledge/subsystems/auth.md)
  and its [stytch-ios dependency concept](https://github.com/occam-bci/atlas-ios/blob/dev/.knowledge/dependencies/stytch-ios.md).

# See also

- [apple-signin.md](apple-signin.md) — the native Sign in with Apple path and its gotchas.
- [../api/public-surface.md](../api/public-surface.md) — the products/clients being imported.

# Citations

[1] [`Package.swift`](../../Package.swift) — products + third-party deps (leaf library).
[2] Saved memory `auth-architecture` — auth lives in auth-proxy + Stytch; backends hold no auth logic.
