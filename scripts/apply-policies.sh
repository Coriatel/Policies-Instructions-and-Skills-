#!/bin/bash

# Apply Cursor Rules and Skills to Target Project
# Usage: ./apply-policies.sh /path/to/target-project

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

# Check if target directory provided
if [ -z "$1" ]; then
    echo -e "${RED}Error: Target project directory required${NC}"
    echo "Usage: $0 /path/to/target-project"
    exit 1
fi

TARGET="$1"

# Verify target exists
if [ ! -d "$TARGET" ]; then
    echo -e "${RED}Error: Target directory does not exist: $TARGET${NC}"
    exit 1
fi

echo -e "${GREEN}=== Applying Development Policies ===${NC}"
echo "From: $REPO_ROOT"
echo "To:   $TARGET"
echo ""

# Function to copy with confirmation
copy_with_confirm() {
    local src="$1"
    local dest="$2"
    local name="$3"

    if [ -e "$dest" ]; then
        echo -e "${YELLOW}$name already exists in target.${NC}"
        read -p "Overwrite? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Skipped $name"
            return 1
        fi
    fi

    cp -r "$src" "$dest"
    echo -e "${GREEN}✓${NC} Copied $name"
    return 0
}

# 1. Copy Cursor Rules
echo "1. Copying Cursor Rules..."
mkdir -p "$TARGET/.cursor"
if copy_with_confirm "$REPO_ROOT/.cursor/rules" "$TARGET/.cursor/rules" "Cursor Rules"; then
    echo "  → .cursor/rules/ directory copied"
fi
echo ""

# 2. Copy Skills (optional)
echo "2. Copying Skills..."
read -p "Copy skills directory? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if copy_with_confirm "$REPO_ROOT/skills" "$TARGET/skills" "Skills"; then
        echo "  → skills/ directory copied"
    fi
fi
echo ""

# 3. Copy Terminal & SSH Policy
echo "3. Copying Terminal & SSH Policy..."
read -p "Copy Terminal & SSH Policy? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    mkdir -p "$TARGET/docs/ops"
    if copy_with_confirm "$REPO_ROOT/docs/ops/TERMINAL_SSH_POLICY.md" "$TARGET/docs/ops/TERMINAL_SSH_POLICY.md" "Terminal Policy"; then
        echo "  → docs/ops/TERMINAL_SSH_POLICY.md copied"
    fi
fi
echo ""

# 4. Create .editorconfig if missing
echo "4. Checking .editorconfig..."
if [ ! -f "$TARGET/.editorconfig" ]; then
    cat > "$TARGET/.editorconfig" << 'EOF'
root = true

[*]
indent_style = space
indent_size = 2
end_of_line = lf
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true

[*.md]
trim_trailing_whitespace = false

[*.py]
indent_size = 4
EOF
    echo -e "${GREEN}✓${NC} Created .editorconfig"
else
    echo "  .editorconfig already exists, skipped"
fi
echo ""

# 5. Summary
echo -e "${GREEN}=== Done! ===${NC}"
echo ""
echo "Applied to: $TARGET"
echo ""
echo "Next steps:"
echo "1. Review copied files in your target project"
echo "2. Customize .cursor/rules/999-overrides.md for project-specific rules"
echo "3. Update your README to reference these policies"
echo ""
echo "Documentation:"
echo "- Usage with Cursor: $REPO_ROOT/docs/USAGE_WITH_CURSOR.md"
echo "- Usage with Claude Code: $REPO_ROOT/docs/USAGE_WITH_CLAUDE_CODE.md"
echo "- Architecture: $REPO_ROOT/docs/ARCHITECTURE_OF_POLICIES.md"
echo ""
