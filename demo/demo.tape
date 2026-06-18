# Requires vhs: brew install vhs
# Usage from the project root: vhs demo/demo.tape

Output demo/demo.gif

Set Shell     "bash"
Set FontSize  14
Set Width     1000
Set Height    600
Set Theme     "Dracula"
Set Padding   16

# Give the shell a moment to be ready
Sleep 1s

# Set up the demo repo
Type "bash demo/setup.sh"
Enter
Sleep 3s

# Navigate into the demo repo and launch git add -p
Type "cd ~/git-ai-demo && git add -p"
Enter

# Hunk 1 — constants + input validation + check_password_hash + token length
# Wait for Claude to annotate, then stage it
Sleep 14s
Type "y"

# Hunk 2 — sessions.pop safety
Sleep 14s
Type "y"

Sleep 2s
