# Homebrew tap for AI Environment Optimizer

Install the latest stable AI Environment Optimizer on macOS:

```sh
brew install nyldn/tap/ai-env-optimizer
ai-env-optimizer setup
ai-env-optimizer doctor
```

Existing `ai-optimizer` formula installs migrate automatically. The legacy
`ai-optimizer` command remains an exact compatibility alias.

Optionally enable owner-scoped maintenance at 19:30 local time:

```sh
brew services start nyldn/tap/ai-env-optimizer
```

This is opt-in, does not run immediately, and can be removed with
`brew services stop nyldn/tap/ai-env-optimizer`. The internal macOS service
label intentionally remains `homebrew.mxcl.ai-optimizer` so upgrades cannot
create a duplicate background job.

Project documentation, release checksums, and build provenance:
[nyldn/ai-env-optimizer](https://github.com/nyldn/ai-env-optimizer).
