#!/bin/bash
set -e

SCRIPT_NAME="git-diff-ai-explainer-interactive-filter"
INSTALL_DIR="/usr/local/bin"

# Determine the directory this install script lives in
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_SRC="$REPO_DIR/$SCRIPT_NAME"

if [ ! -f "$SCRIPT_SRC" ]; then
  echo "Error: $SCRIPT_NAME not found in $REPO_DIR" >&2
  exit 1
fi

# Check for claude CLI
if ! command -v claude &>/dev/null; then
  echo "Warning: 'claude' CLI not found in PATH."
  echo "Install it from https://claude.ai/code and authenticate before using this tool."
fi

# Install
chmod +x "$SCRIPT_SRC"

if [ -w "$INSTALL_DIR" ]; then
  cp "$SCRIPT_SRC" "$INSTALL_DIR/$SCRIPT_NAME"
else
  echo "Installing to $INSTALL_DIR (requires sudo)..."
  sudo cp "$SCRIPT_SRC" "$INSTALL_DIR/$SCRIPT_NAME"
fi

echo ""
echo "Installed: $INSTALL_DIR/$SCRIPT_NAME"
echo ""
echo "Usage:"
echo "  git diff | $SCRIPT_NAME"
echo ""
echo "Or add an alias to your shell profile:"
echo "  alias gda='git diff | $SCRIPT_NAME | less -R'"
