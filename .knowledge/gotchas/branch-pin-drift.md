---
type: Gotcha
title: Consumers pin a branch, not a release
description: atlas-ios / atlas-lab-ios pin the fix branch by name, so the resolved SPM revision drifts as the branch moves; there is no semver contract.
resource: https://github.com/occam-bci/stytch-ios/tree/fix/encryption_key_rotation_on_relaunch
tags: [spm, branch-pin, versioning, drift, fork]
timestamp: 2026-07-17T00:00:00Z
---

# The trap

The Atlas apps depend on this fork by **branch**, not tag:

```
.package(url: "https://github.com/occam-bci/stytch-ios", branch: "fix/encryption_key_rotation_on_relaunch")
```

Upstream's own README explicitly warns *"never point to `main` or any other branch directly"* — the fork
deliberately breaks that rule to ship the encryption-key fix ahead of an upstream release. Consequences:

- **The resolved revision drifts.** Any push to the branch (including an upstream-sync merge) changes what
  consumers get on their next `Package.resolved` update — with no semver signal. Confirm the pinned commit in
  each app's `Package.resolved`, not just the branch name.
- **No release notes.** Because it is a branch, there is no tag/changelog for the delta — [../architecture/fork-delta.md](../architecture/fork-delta.md) is the record.

# What to do

- When bumping the pin, read the resolved commit and re-verify the delta is still just `ab363ff` on top of
  upstream (`git log --oneline upstream/main..origin/fix/encryption_key_rotation_on_relaunch`).
- **Exit criterion:** once upstream ships a release containing an equivalent fix, migrate consumers back to a
  tagged upstream/fork release and retire the branch pin.

# See also

- [../integrations/atlas-consumers.md](../integrations/atlas-consumers.md) — which apps pin this and how.
- [../build/ci-and-release.md](../build/ci-and-release.md) — versioning + upstream-sync.

# Citations

[1] [`README.md`](../../README.md) — "never point to `main` or any other branch directly".
[2] Saved memory `stytch-ios` dependency-map fact: apps pin branch `fix/encryption_key_rotation_on_relaunch`.
