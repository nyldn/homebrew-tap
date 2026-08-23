# Homebrew tap for AI Optimizer

Install the latest stable AI Optimizer on macOS:

```sh
brew install nyldn/tap/ai-optimizer
ai-optimizer setup
ai-optimizer doctor
```

Optionally enable owner-scoped maintenance at 19:30 local time:

```sh
brew services start nyldn/tap/ai-optimizer
```

This is opt-in, does not run immediately, and can be removed with
`brew services stop nyldn/tap/ai-optimizer`.

Project documentation, release checksums, and build provenance:
[nyldn/ai-optimizer](https://github.com/nyldn/ai-optimizer).
