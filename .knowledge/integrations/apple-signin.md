---
type: Integration
title: Native Sign in with Apple via Stytch
description: SIWA is native (not web) through this SDK; Apple team 5N3X2A262P, two Stytch environments, staging unsupported, and the "oauth2" label in Apple settings is a frozen per-sub label.
resource: https://github.com/occam-bci/stytch-ios/tree/main/Sources/StytchCore/AppleOAuthClient
tags: [apple-signin, siwa, oauth, stytch-env, gotcha]
timestamp: 2026-07-17T00:00:00Z
---

Atlas does Sign in with Apple **natively** through this SDK (the `AppleOAuthClient` /
[`StytchClient.oauth`](../../Sources/StytchCore/AppleOAuthClient/) Apple path), not via a web redirect. The
topology and its subtleties live mostly in the consumer apps + the Stytch/Apple dashboards; recorded here
because this fork provides the code path.

# Facts

- **Native, via Stytch.** The app presents the Apple sheet and hands the credential to Stytch; there is no
  in-app web "Continue with Apple" redirect on the native flow.
- **Apple Developer team:** `5N3X2A262P`.
- **Two Stytch environments** (test / live). Match the environment to the build; a token minted for one env
  will not validate against the other.

# Pitfalls

- **Staging SIWA is unsupported.** The staging build cannot complete native Sign in with Apple — do not treat a
  staging SIWA failure as a regression. (In atlas-ios this is gated by an exhaustive `AppEnvironment` capability,
  e.g. `allowsAppleSignIn`.)
- **The `"oauth2"` label is frozen, not a live identifier.** In Apple ID settings, the string Apple shows next
  to the app (e.g. `"oauth2"`) is a **per-`sub` label Apple freezes at the user's first sign-in**. It is a
  historical display label, **not** a live client/redirect identifier — do not parse it or key logic off it.
- **Domains:** the web "Continue with Apple" live redirect (used off-device) is on `occam-atlas.com`; the Apple
  setup-helper "Return URL" field is misleading. Any domain change must be **add-before-remove**.

# See also

- [atlas-consumers.md](atlas-consumers.md) — server-side auth ownership (auth-proxy + Stytch).
- [../api/public-surface.md](../api/public-surface.md) — the OAuth namespace on `StytchClient`.

# Citations

[1] [`Sources/StytchCore/AppleOAuthClient/`](../../Sources/StytchCore/AppleOAuthClient/) — native Apple OAuth path.
[2] Saved memory `apple-signin-atlas-config` — team `5N3X2A262P`, two Stytch envs, staging unsupported, frozen `"oauth2"` per-`sub` label, `occam-atlas.com` redirect, add-before-remove.
