# Using This Policy Library with Claude Code CLI

## Quick Start

### Option 1: Reference in Session
Point Claude Code to this repository at the start of your session:

```bash
# Start Claude Code session
claude-code

# In the conversation:
"I'm working on a project. Please refer to the development policies
in /path/to/Policies-Instructions-and-Skills for all code standards,
patterns, and workflows."
```

### Option 2: Copy Rules to Project
```bash
# Copy rules to your project
cp -r /path/to/Policies-Instructions-and-Skills/.cursor/rules /path/to/your-project/.cursor/

# Claude Code can read these automatically if configured
```

### Option 3: Use Skills Directly
Copy skill files into your prompts:

```bash
"I need to add a new API endpoint. Here's the skill to follow:

[paste contents of skills/api-express/skill.md]
"
```

## How Claude Code Uses Policies

Claude Code can access policies through:

1. **Direct file reading** - If policies are in your project directory
2. **Pasted skills** - Copy/paste skill.md files into conversation
3. **Referenced documentation** - Point to this repository

## Workflow Patterns

### Pattern 1: Policy-First Development
```markdown
1. User: "Add user authentication"
2. Claude reads: .cursor/rules/060-auth-rbac.md
3. Claude executes: skills/auth-rbac/skill.md
4. Result: JWT auth with RBAC, following all security policies
```

### Pattern 2: Skill-Driven Execution
```markdown
1. User pastes: skills/tables/skill.md
2. User: "Create a sortable users table"
3. Claude follows skill steps
4. Claude references: .cursor/rules/040-tables-forms.md for styling
5. Result: Accessible, RTL-aware, sortable table
```

### Pattern 3: Terminal Operations
```markdown
1. User: "Deploy to VPS"
2. Claude reads: docs/ops/TERMINAL_SSH_POLICY.md
3. Claude follows: skills/terminal-ssh-vps/skill.md
4. Claude asks for confirmation before destructive operations
5. Result: Safe deployment with proper logging
```

## Using Skills

### Short Skills (skill.md)
These are designed to be copy/pasted:

```bash
# Copy a skill
cat /path/to/Policies-Instructions-and-Skills/skills/api-express/skill.md | pbcopy

# In Claude Code conversation
"Here's the skill to follow: [paste]"
```

### Deep Details (details/)
Claude Code can read these for additional context:

```markdown
"I need more examples for RTL layout. Please read:
/path/to/Policies-Instructions-and-Skills/skills/rtl-hebrew/details/examples.md"
```

## Configuration

### Project-Level Configuration
Create a `.claude-code-config.json` in your project:

```json
{
  "policies": "/path/to/Policies-Instructions-and-Skills",
  "rules_dir": ".cursor/rules",
  "skills_dir": "skills"
}
```

### Session-Level Instructions
At the start of each session:

```markdown
Project context:
- Follow policies in /path/to/Policies-Instructions-and-Skills
- Use skills from /path/to/Policies-Instructions-and-Skills/skills
- Always check Terminal & SSH Policy before running commands
- Ask for confirmation before destructive operations
```

## Best Practices

### ✅ DO
- Reference policies at session start
- Use skills for step-by-step tasks
- Leverage Terminal & SSH Policy for safety
- Ask Claude to read specific rule files when needed
- Use skills as autonomous execution guides

### ❌ DON'T
- Don't assume Claude remembers policies across sessions
- Don't skip safety confirmations (especially terminal ops)
- Don't paste entire rule files (too long - use skills instead)
- Don't ignore skill validation steps

## Safety with Terminal Operations

Claude Code can execute terminal commands. Always ensure:

1. **Terminal & SSH Policy is referenced**:
   ```markdown
   "Before any terminal command, follow:
   /path/to/Policies-Instructions-and-Skills/docs/ops/TERMINAL_SSH_POLICY.md"
   ```

2. **Confirmation gates are respected**:
   - Destructive operations require explicit approval
   - Secrets are never echoed
   - Production commands are confirmed

3. **Skills include safety checks**:
   - terminal-ssh-vps skill has built-in safety guidelines
   - Always review proposed commands before execution

## Examples

### Example 1: Add API Endpoint
```markdown
User: "Add a new API endpoint for managing products"

Claude: "I'll add a REST API endpoint following the api-express skill.
First, let me read the API rules..."

[Claude reads: .cursor/rules/050-api-express.md]
[Claude follows: skills/api-express/skill.md]

Claude creates:
- routes/products.routes.js
- controllers/products.controller.js
- validation/products.validation.js
- Tests
```

### Example 2: Implement RTL UI
```markdown
User: "Convert this component to support RTL"

[User pastes: skills/rtl-hebrew/skill.md]

Claude: "I'll convert to RTL following the skill steps..."

[Claude reads: .cursor/rules/030-rtl-hebrew.md]

Claude updates:
- Changes to logical CSS properties
- Adds dir="rtl" handling
- Isolates LTR content (emails, numbers)
- Updates i18n configuration
```

### Example 3: Deploy to VPS
```markdown
User: "Deploy the app to my VPS"

Claude: "I'll follow the terminal-ssh-vps skill. First, I need to
confirm this follows the Terminal & SSH Policy..."

[Claude reads: docs/ops/TERMINAL_SSH_POLICY.md]
[Claude reads: skills/terminal-ssh-vps/skill.md]

Claude: "I'm about to run these commands on your VPS:
1. ssh user@host 'systemctl stop app'
2. scp -r build/ user@host:/var/www/app/
3. ssh user@host 'systemctl start app'

⚠️ This will stop your production app. Proceed? (yes/no)"
```

## Updating Policies

```bash
# Pull latest from repository
cd /path/to/Policies-Instructions-and-Skills
git pull

# Tell Claude Code in new session
"I've updated the policies repository. Please use the latest rules."
```

## See Also

- [Skills README](/skills/README.md) — Skills system overview
- [Terminal & SSH Policy](/docs/ops/TERMINAL_SSH_POLICY.md) — Safety guidelines
- [Architecture of Policies](/docs/ARCHITECTURE_OF_POLICIES.md) — How everything fits together

---

**Last Updated**: 2025-12-31
