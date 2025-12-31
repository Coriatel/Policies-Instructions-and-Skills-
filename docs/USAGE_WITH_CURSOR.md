# Using This Policy Library with Cursor IDE

## Quick Start

### Option 1: Copy Rules to Your Project (Recommended)
```bash
# Clone this repository
git clone https://github.com/yourorg/Policies-Instructions-and-Skills.git

# Copy .cursor/rules/ to your project
cp -r Policies-Instructions-and-Skills/.cursor/rules/ /path/to/your-project/.cursor/

# Cursor will automatically load rules from .cursor/rules/
```

### Option 2: Use Single .cursorrules File
```bash
# Combine all rules into one file
cd /path/to/your-project
cat path/to/Policies-Instructions-and-Skills/.cursor/rules/*.md > .cursorrules
```

### Option 3: Use Apply Script
```bash
# Use the provided helper script
./Policies-Instructions-and-Skills/scripts/apply-policies.sh /path/to/your-project
```

## How Cursor Loads Rules

Cursor IDE loads rules in this order:
1. `.cursor/rules/*.md` (all files, alphabetically)
2. `.cursorrules` (root file, if exists)

**Recommendation**: Use `.cursor/rules/` for modular organization.

## Customizing for Your Project

### Add Project-Specific Rules
Create additional rule files in your project:

```bash
# Your project
.cursor/rules/
├── 000-overview.md        # From this library
├── 010-code-style-js.md  # From this library
├── ...
├── 110-project-database-schema.md  # Your custom rule
└── 999-project-overrides.md        # Your overrides
```

### Override Default Rules
Create a high-numbered override file:

```markdown
<!-- .cursor/rules/999-overrides.md -->
# Project Overrides

## TypeScript Instead of JavaScript
This project uses TypeScript. Apply JavaScript patterns from
`010-code-style-js.md` but use `.ts` and `.tsx` extensions.

## Custom API Structure
Our API uses GraphQL, not REST. See internal docs for patterns.
```

### Disable Specific Rules
If a rule doesn't apply, either:
1. **Delete the file** from your local `.cursor/rules/`
2. **Add a comment** at the top: `<!-- DISABLED: Not applicable -->`

## Using with Skills

Skills work hand-in-hand with rules:

1. **Rules** define policies (what/why)
2. **Skills** provide execution steps (how)

### Example Workflow

```markdown
<!-- In Cursor chat -->
Add a new API endpoint for managing products.

Use the api-express skill from this repository:
[paste contents of skills/api-express/skill.md]
```

Cursor will:
1. Read rules from `.cursor/rules/050-api-express.md`
2. Follow steps from the skill
3. Implement following both policy and process

## Updating Rules

### From This Repository
```bash
# Pull latest changes
cd path/to/Policies-Instructions-and-Skills
git pull

# Re-copy to your project
cp -r .cursor/rules/ /path/to/your-project/.cursor/
```

### Selective Updates
```bash
# Update only specific rules
cp .cursor/rules/050-api-express.md /path/to/your-project/.cursor/rules/
cp .cursor/rules/100-security-secrets.md /path/to/your-project/.cursor/rules/
```

## Best Practices

### ✅ DO
- Copy rules to your project (don't link/reference externally)
- Add project-specific rules as needed
- Keep rule files modular (one concern per file)
- Update periodically from this repository
- Document customizations in 999-overrides.md

### ❌ DON'T
- Don't modify core rule files directly (use overrides instead)
- Don't commit secrets in rule examples
- Don't create overlapping/contradictory rules
- Don't skip reviewing rules before adopting them

## Troubleshooting

### Rules Not Loading
- Check file extension is `.md`
- Verify file is in `.cursor/rules/` directory
- Check Cursor settings for rules configuration
- Restart Cursor IDE

### Conflicting Rules
- Review all active rules
- Use 999-overrides.md to clarify precedence
- Remove or disable conflicting rule files

### Rule Too Generic
- Add project-specific details in override file
- Create 110+ numbered files for custom rules
- Reference but don't modify core rules

## Examples

### Minimal Setup (Just Core Rules)
```
your-project/
├── .cursor/
│   └── rules/
│       ├── 010-code-style-js.md
│       ├── 050-api-express.md
│       └── 100-security-secrets.md
└── src/
```

### Full Setup (All Rules + Custom)
```
your-project/
├── .cursor/
│   └── rules/
│       ├── 000-overview.md
│       ├── 010-code-style-js.md
│       ├── 020-ui-react-scss-a11y.md
│       ├── 030-rtl-hebrew.md
│       ├── ... (all core rules)
│       ├── 110-project-conventions.md
│       └── 999-overrides.md
└── src/
```

## See Also

- [Skills README](/skills/README.md) — How to use skills with Cursor
- [Architecture of Policies](/docs/ARCHITECTURE_OF_POLICIES.md) — How rules and skills relate
- [Contributing](/docs/CONTRIBUTING.md) — How to extend this library

---

**Last Updated**: 2025-12-31
