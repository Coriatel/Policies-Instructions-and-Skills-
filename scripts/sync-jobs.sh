#!/bin/bash

# AI_JOBS.md Sync Script
# Syncs between local VPS-specific file and git template

LOCAL_FILE="/root/AI_JOBS.md"
TEMPLATE_FILE="/root/policies-repo/AI_JOBS_TEMPLATE.md"
BACKUP_DIR="/root/.job-backups"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Ensure backup directory exists
mkdir -p "$BACKUP_DIR"

show_help() {
  echo -e "${BLUE}AI_JOBS.md Sync Script${NC}"
  echo ""
  echo "Usage: $0 [command]"
  echo ""
  echo "Commands:"
  echo "  pull      Pull template structure from git (preserves your data)"
  echo "  push      Push your local structure to template (sanitizes VPS-specific data)"
  echo "  backup    Create backup of local file"
  echo "  restore   Restore from latest backup"
  echo "  diff      Show differences between local and template"
  echo "  status    Show sync status"
  echo ""
  echo "Examples:"
  echo "  $0 pull      # Update local file with template structure"
  echo "  $0 push      # Update template with your structure"
  echo "  $0 backup    # Backup local file before making changes"
  echo ""
}

backup_local() {
  if [ ! -f "$LOCAL_FILE" ]; then
    echo -e "${RED}Error: Local file not found at $LOCAL_FILE${NC}"
    return 1
  fi

  TIMESTAMP=$(date +%Y%m%d_%H%M%S)
  BACKUP_FILE="$BACKUP_DIR/AI_JOBS_${TIMESTAMP}.md"

  cp "$LOCAL_FILE" "$BACKUP_FILE"
  echo -e "${GREEN}✅ Backup created: $BACKUP_FILE${NC}"

  # Keep only last 10 backups
  ls -t "$BACKUP_DIR"/AI_JOBS_*.md | tail -n +11 | xargs -r rm
  echo -e "${BLUE}ℹ️  Keeping last 10 backups${NC}"
}

restore_backup() {
  LATEST_BACKUP=$(ls -t "$BACKUP_DIR"/AI_JOBS_*.md 2>/dev/null | head -n 1)

  if [ -z "$LATEST_BACKUP" ]; then
    echo -e "${RED}Error: No backups found in $BACKUP_DIR${NC}"
    return 1
  fi

  echo -e "${YELLOW}Latest backup: $LATEST_BACKUP${NC}"
  read -p "Restore this backup? (y/n): " -n 1 -r
  echo

  if [[ $REPLY =~ ^[Yy]$ ]]; then
    cp "$LATEST_BACKUP" "$LOCAL_FILE"
    echo -e "${GREEN}✅ Restored from backup${NC}"
  else
    echo -e "${BLUE}Restore cancelled${NC}"
  fi
}

show_diff() {
  if [ ! -f "$LOCAL_FILE" ]; then
    echo -e "${RED}Error: Local file not found${NC}"
    return 1
  fi

  if [ ! -f "$TEMPLATE_FILE" ]; then
    echo -e "${RED}Error: Template file not found${NC}"
    return 1
  fi

  echo -e "${BLUE}=== Differences between Local and Template ===${NC}"
  echo ""
  diff -u "$TEMPLATE_FILE" "$LOCAL_FILE" | head -50
  echo ""
  echo -e "${YELLOW}Showing first 50 lines of diff. Use 'diff -u $TEMPLATE_FILE $LOCAL_FILE' for full output${NC}"
}

show_status() {
  echo -e "${BLUE}=== AI_JOBS.md Sync Status ===${NC}"
  echo ""

  if [ -f "$LOCAL_FILE" ]; then
    LOCAL_SIZE=$(stat -f%z "$LOCAL_FILE" 2>/dev/null || stat -c%s "$LOCAL_FILE" 2>/dev/null)
    LOCAL_LINES=$(wc -l < "$LOCAL_FILE")
    LOCAL_UPDATED=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M" "$LOCAL_FILE" 2>/dev/null || stat -c "%y" "$LOCAL_FILE" 2>/dev/null | cut -d'.' -f1)
    echo -e "📄 Local File: ${GREEN}EXISTS${NC}"
    echo "   Path: $LOCAL_FILE"
    echo "   Size: $(numfmt --to=iec-i --suffix=B $LOCAL_SIZE 2>/dev/null || echo "$LOCAL_SIZE bytes")"
    echo "   Lines: $LOCAL_LINES"
    echo "   Updated: $LOCAL_UPDATED"
  else
    echo -e "📄 Local File: ${RED}NOT FOUND${NC}"
  fi

  echo ""

  if [ -f "$TEMPLATE_FILE" ]; then
    TEMPLATE_SIZE=$(stat -f%z "$TEMPLATE_FILE" 2>/dev/null || stat -c%s "$TEMPLATE_FILE" 2>/dev/null)
    TEMPLATE_LINES=$(wc -l < "$TEMPLATE_FILE")
    TEMPLATE_UPDATED=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M" "$TEMPLATE_FILE" 2>/dev/null || stat -c "%y" "$TEMPLATE_FILE" 2>/dev/null | cut -d'.' -f1)
    echo -e "📝 Template File: ${GREEN}EXISTS${NC}"
    echo "   Path: $TEMPLATE_FILE"
    echo "   Size: $(numfmt --to=iec-i --suffix=B $TEMPLATE_SIZE 2>/dev/null || echo "$TEMPLATE_SIZE bytes")"
    echo "   Lines: $TEMPLATE_LINES"
    echo "   Updated: $TEMPLATE_UPDATED"
  else
    echo -e "📝 Template File: ${RED}NOT FOUND${NC}"
  fi

  echo ""

  BACKUP_COUNT=$(ls "$BACKUP_DIR"/AI_JOBS_*.md 2>/dev/null | wc -l)
  echo "💾 Backups: $BACKUP_COUNT in $BACKUP_DIR"

  if [ $BACKUP_COUNT -gt 0 ]; then
    LATEST_BACKUP=$(ls -t "$BACKUP_DIR"/AI_JOBS_*.md | head -n 1)
    LATEST_BACKUP_DATE=$(basename "$LATEST_BACKUP" | sed 's/AI_JOBS_\(.*\)\.md/\1/')
    echo "   Latest: $LATEST_BACKUP_DATE"
  fi

  echo ""

  # Check git status
  cd /root/policies-repo
  if git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "🔗 Git Repository: ${GREEN}CONNECTED${NC}"
    BRANCH=$(git branch --show-current)
    echo "   Branch: $BRANCH"

    if git diff --quiet AI_JOBS_TEMPLATE.md 2>/dev/null; then
      echo -e "   Template Status: ${GREEN}CLEAN (no uncommitted changes)${NC}"
    else
      echo -e "   Template Status: ${YELLOW}MODIFIED (uncommitted changes)${NC}"
    fi
  else
    echo -e "🔗 Git Repository: ${RED}NOT FOUND${NC}"
  fi
}

pull_from_template() {
  echo -e "${BLUE}=== Pulling Template Updates ===${NC}"
  echo ""

  # Check if files exist
  if [ ! -f "$TEMPLATE_FILE" ]; then
    echo -e "${RED}Error: Template file not found at $TEMPLATE_FILE${NC}"
    echo "Run 'cd /root/policies-repo && git pull' first"
    return 1
  fi

  if [ ! -f "$LOCAL_FILE" ]; then
    echo -e "${YELLOW}Local file not found. Creating new file from template...${NC}"
    cp "$TEMPLATE_FILE" "$LOCAL_FILE"
    echo -e "${GREEN}✅ Created $LOCAL_FILE from template${NC}"
    echo -e "${YELLOW}⚠️  Remember to customize with your VPS-specific details!${NC}"
    return 0
  fi

  # Backup before making changes
  echo "Creating backup before pulling..."
  backup_local

  echo ""
  echo -e "${YELLOW}⚠️  WARNING: This will update the STRUCTURE of your local file.${NC}"
  echo -e "${YELLOW}    Your tasks and data will be preserved, but template sections may update.${NC}"
  echo ""
  read -p "Continue? (y/n): " -n 1 -r
  echo

  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${BLUE}Pull cancelled${NC}"
    return 0
  fi

  # Update git template first
  cd /root/policies-repo
  git pull origin $(git branch --show-current)

  echo ""
  echo -e "${BLUE}ℹ️  Manual merge required:${NC}"
  echo "1. Review template: $TEMPLATE_FILE"
  echo "2. Compare with local: $LOCAL_FILE"
  echo "3. Manually apply structure updates while keeping your data"
  echo ""
  echo "Use: diff -y $TEMPLATE_FILE $LOCAL_FILE | less"
  echo ""
  echo -e "${YELLOW}Note: Automated merging not implemented to prevent data loss.${NC}"
  echo -e "${YELLOW}      Backup saved in: $BACKUP_DIR${NC}"
}

push_to_template() {
  echo -e "${BLUE}=== Pushing Local Structure to Template ===${NC}"
  echo ""

  if [ ! -f "$LOCAL_FILE" ]; then
    echo -e "${RED}Error: Local file not found at $LOCAL_FILE${NC}"
    return 1
  fi

  echo -e "${YELLOW}⚠️  This will update the template with your local structure.${NC}"
  echo -e "${YELLOW}    VPS-specific data will be sanitized (replaced with placeholders).${NC}"
  echo ""
  read -p "Continue? (y/n): " -n 1 -r
  echo

  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${BLUE}Push cancelled${NC}"
    return 0
  fi

  # Create sanitized version
  TEMP_FILE="/tmp/AI_JOBS_sanitized.md"

  # Copy local file and sanitize
  cp "$LOCAL_FILE" "$TEMP_FILE"

  # Replace VPS-specific domains with placeholders
  sed -i 's/coriathost\.cloud/example.com/g' "$TEMP_FILE"
  sed -i 's/flow\.coriathost\.cloud/service1.example.com/g' "$TEMP_FILE"
  sed -i 's/n8n\.coriathost\.cloud/service2.example.com/g' "$TEMP_FILE"
  sed -i 's/give\.coriathost\.cloud/service3.example.com/g' "$TEMP_FILE"
  sed -i 's/crmlite\.coriathost\.cloud/service4.example.com/g' "$TEMP_FILE"

  # Replace specific paths with generic ones
  sed -i 's/\/home\/elron\/services/\/path\/to\/services/g' "$TEMP_FILE"
  sed -i 's/\/opt\/flow-control/\/path\/to\/app/g' "$TEMP_FILE"

  # Update header
  sed -i '1s/.*/# AI Agent Job Tracker - TEMPLATE/' "$TEMP_FILE"
  sed -i "s/Last Updated:.*/Last Template Update: $(date +%Y-%m-%d)/" "$TEMP_FILE"

  # Copy to template location
  cp "$TEMP_FILE" "$TEMPLATE_FILE"
  rm "$TEMP_FILE"

  echo -e "${GREEN}✅ Template updated at: $TEMPLATE_FILE${NC}"
  echo ""
  echo "Next steps:"
  echo "1. Review the template: cat $TEMPLATE_FILE"
  echo "2. Commit to git:"
  echo "   cd /root/policies-repo"
  echo "   git add AI_JOBS_TEMPLATE.md"
  echo "   git commit -m 'docs: update AI_JOBS_TEMPLATE structure'"
  echo "   git push"
}

# Main command handling
case "${1}" in
  pull)
    pull_from_template
    ;;
  push)
    push_to_template
    ;;
  backup)
    backup_local
    ;;
  restore)
    restore_backup
    ;;
  diff)
    show_diff
    ;;
  status)
    show_status
    ;;
  help|--help|-h)
    show_help
    ;;
  *)
    if [ -z "$1" ]; then
      show_help
    else
      echo -e "${RED}Error: Unknown command '$1'${NC}"
      echo ""
      show_help
      exit 1
    fi
    ;;
esac
