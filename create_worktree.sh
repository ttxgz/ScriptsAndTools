#!/bin/bash
set -e

# Usage: source ~/ScriptsAndTools/create_worktree.sh <branch-name>
# Example: . ~/ScriptsAndTools/create_worktree.sh devin/1782173548-fix-rtmp-writedata-backpressure

if [ -z "$1" ]; then
    echo "Error: Branch name required"
    echo "Usage: source $0 <branch-name>"
    echo "Example: . $0 devin/1782173548-fix-rtmp-writedata-backpressure"
    return 1 2>/dev/null || exit 1
fi

BRANCH_NAME="$1"

# Extract the last part after the last slash
LAST_PART="${BRANCH_NAME##*/}"

# Construct worktree path
WORKTREE_PATH="./worktree/pr_${LAST_PART}"

echo "Creating worktree for branch: $BRANCH_NAME"
echo "Worktree path: $WORKTREE_PATH"

# Create worktree
git worktree add -b "$BRANCH_NAME" "$WORKTREE_PATH" "origin/$BRANCH_NAME"

# Create symlink to .claude (do this without cd-ing)
(cd "$WORKTREE_PATH" && ln -s ../../.claude .claude)

echo ""
echo "✓ Worktree created successfully!"
echo "✓ Symlink to .claude created"
echo ""

# cd into the worktree
cd "$WORKTREE_PATH"

# echo "✓ Now in: $(pwd)"
