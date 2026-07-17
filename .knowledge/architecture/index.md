# Architecture

This fork adds **no architecture** of its own — the SDK design (client singletons, `Current` dependency
container, networking routers, `StartupClient` bootstrap, keychain client) is all upstream. The one concept
here explains **why the fork exists** and the exact code it changes.

# Concepts

* [fork-delta.md](fork-delta.md) - the single first-party commit vs upstream, the keychain encryption-key race it fixes, and the upstream-sync model
