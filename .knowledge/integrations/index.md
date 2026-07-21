# Integrations

How this fork is consumed by the Atlas apps, and the one integration path with fork-relevant subtleties: native
Sign in with Apple. Most of the config for these lives in the **consumer apps** and the Stytch/Apple dashboards,
not in this repo — captured here for context because the SDK provides the path.

# Concepts

* [atlas-consumers.md](atlas-consumers.md) - who imports this fork, which products, and where the auth logic actually lives (server-side)
* [apple-signin.md](apple-signin.md) - native Sign in with Apple via Stytch: team, two envs, staging unsupported, the frozen `"oauth2"` label
