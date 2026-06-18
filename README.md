# git-diff-ai-explainer-interactive-filter

A Git diff filter that uses Claude AI to annotate every changed line with a concise, one-sentence explanation — inline, right in your terminal.

```
-    return user.age >= 18;
+    return user.age >= 21;   <-- 🤖 Raised the legal age threshold from 18 to 21
```

Designed to work seamlessly with `git add -p` (interactive staging), so you understand exactly what each hunk does before you stage it.

![demo](demo/demo.gif)

## Why

AI coding tools (Copilot, Cursor, Claude) are fast — but they generate code you didn't write and may not fully understand. When you run `git add -p` to selectively stage that output, it's easy to end up committing code you didn't really review.

This filter puts a second AI in the loop at exactly that moment. Before you decide to stage a hunk, every changed line already has a plain-English explanation attached to it — what changed, and why it matters. You stay in control without having to context-switch to read the diff cold.

It's also useful outside AI workflows: reviewing a colleague's PR locally, digging into an unfamiliar codebase, or just double-checking your own changes before a commit.

## How it works

The script reads a Git diff stream from stdin, strips ANSI color codes so Claude can parse the raw text, sends the numbered diff to Claude (via the `claude` CLI), and weaves the AI-generated explanations back into the original colored output — appended inline to each changed line.

## Prerequisites

- [Claude Code CLI](https://claude.ai/code) — must be installed and authenticated (`claude` available in your PATH)
- `bash` (v3.2+)
- `perl` (for ANSI stripping)
- `awk` (for line weaving)

All three shell tools are pre-installed on macOS and most Linux distributions.

## Installation

### Automatic

```bash
curl -fsSL https://raw.githubusercontent.com/kooskoos20/git-diff-ai-explainer-interactive-filter/main/install.sh | bash
```

### Manual

```bash
# Clone the repo
git clone https://github.com/kooskoos20/git-diff-ai-explainer-interactive-filter.git
cd git-diff-ai-explainer-interactive-filter

# Run the installer
bash install.sh
```

Or install just the script to your PATH:

```bash
chmod +x git-diff-ai-explainer-interactive-filter
sudo cp git-diff-ai-explainer-interactive-filter /usr/local/bin/
```

## Usage

### `git add -p` (primary use case)

Configure Git to run the filter automatically whenever you use interactive staging:

```bash
git config --global interactive.diffFilter git-diff-ai-explainer-interactive-filter
```

Now every `git add -p` session will show AI annotations inline as you step through hunks. Git passes the diff with colors already intact, so no extra flags are needed.

To apply it to a single repo only, omit `--global`.

### One-off via pipe

Git disables colors when stdout is a pipe, so pass `--color=always` to preserve them:

```bash
git diff --color=always | git-diff-ai-explainer-interactive-filter
git diff --color=always HEAD~1 | git-diff-ai-explainer-interactive-filter
git show --color=always abc1234 | git-diff-ai-explainer-interactive-filter
```

Useful aliases to add to `~/.bashrc` or `~/.zshrc`:

```bash
alias gda='git diff --color=always | git-diff-ai-explainer-interactive-filter | less -R'
alias gdca='git diff --cached --color=always | git-diff-ai-explainer-interactive-filter | less -R'
```

## Configuration

The script uses Claude's `haiku` model by default for speed and cost efficiency. To change the model, edit line 34 in the script:

```bash
# Default (fast, cheap)
CLAUDE_OUT=$(echo "$CLAUDE_PROMPT" | claude --model haiku)

# Higher quality explanations
CLAUDE_OUT=$(echo "$CLAUDE_PROMPT" | claude --model sonnet)
```

## Uninstall

```bash
rm /usr/local/bin/git-diff-ai-explainer-interactive-filter

# If you configured the interactive diff filter, remove it:
git config --global --unset interactive.diffFilter
```

## Contributing

Contributions are welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

[MIT](LICENSE)
