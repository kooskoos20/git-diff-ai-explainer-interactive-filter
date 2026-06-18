#!/bin/bash
# Sets up a throwaway git repo with staged changes ready for `git add -p`.
# Does NOT launch git add -p — run it yourself after this script exits.
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPT_PATH="$SCRIPT_DIR/git-diff-ai-explainer-interactive-filter"
DEMO_DIR="$HOME/git-ai-demo"

# ── Verify the filter script exists ──────────────────────────────────────────
if [ ! -x "$SCRIPT_PATH" ]; then
  echo "Error: filter script not found or not executable at $SCRIPT_PATH" >&2
  exit 1
fi

# ── Clean slate ───────────────────────────────────────────────────────────────
rm -rf "$DEMO_DIR"
mkdir -p "$DEMO_DIR"
cd "$DEMO_DIR"

git init -q
git config user.name        "Demo User"
git config user.email       "demo@example.com"
git config commit.gpgsign   false
git config interactive.diffFilter "$SCRIPT_PATH"

# ── Initial file ──────────────────────────────────────────────────────────────
cat > auth.py << 'PYTHON'
MAX_LOGIN_ATTEMPTS = 3
SESSION_TIMEOUT    = 1800  # seconds

def authenticate(username, password):
    user = db.find_user(username)
    if user and user.password == password:
        return create_session(user)
    return None

def create_session(user):
    token = generate_token(length=16)
    sessions[token] = {
        "user":    user.id,
        "expires": time.time() + SESSION_TIMEOUT,
    }
    return token

def logout(token):
    sessions.pop(token)
PYTHON

git add auth.py
git commit -q -m "Add authentication module"

# ── Apply changes (three separate hunks) ─────────────────────────────────────
cat > auth.py << 'PYTHON'
MAX_LOGIN_ATTEMPTS = 5
SESSION_TIMEOUT    = 3600  # seconds

def authenticate(username, password):
    if not username or not password:
        return None
    user = db.find_user(username)
    if user and check_password_hash(user.password, password):
        return create_session(user)
    return None

def create_session(user):
    token = generate_token(length=32)
    sessions[token] = {
        "user":    user.id,
        "expires": time.time() + SESSION_TIMEOUT,
    }
    return token

def logout(token):
    sessions.pop(token, None)
PYTHON

echo ""
echo "Demo repo ready at: $DEMO_DIR"
echo "Run: cd $DEMO_DIR && git add -p"
