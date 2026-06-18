# Contributing

Contributions are welcome — bug reports, feature requests, and pull requests alike.

## Reporting bugs

Open an issue and include:

- Your OS and shell (`uname -a`, `bash --version`)
- The `claude` CLI version (`claude --version`)
- A minimal reproduction (sanitized diff input if possible)
- The actual vs. expected output

## Suggesting features

Open an issue describing the use case. Prefer concrete examples over abstract descriptions.

## Pull requests

1. Fork the repo and create a branch from `main`.
2. Make your changes to the script.
3. Test manually:
   ```bash
   # Basic smoke test
   git diff HEAD~1 | ./git-diff-ai-explainer-interactive-filter

   # Empty input should exit cleanly
   echo "" | ./git-diff-ai-explainer-interactive-filter
   ```
4. Keep changes focused — one fix or feature per PR.
5. Update `README.md` if you add or change user-facing behavior.
6. Open the pull request with a clear description of what and why.

## Code style

- POSIX-compatible `sh` where possible; `bash`-specific syntax only when necessary.
- Keep the script self-contained — no external dependencies beyond `bash`, `perl`, `awk`, and the `claude` CLI.
- Prefer clarity over cleverness in `awk` and `perl` expressions.
