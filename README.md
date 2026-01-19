# Development Policy Library

**Reusable Cursor Rules + Claude Skills for Consistent Software Development**

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Last Updated](https://img.shields.io/badge/updated-2025--12--31-green.svg)

## 🎯 What Is This?

A comprehensive, modular library of:
- **Cursor Rules** (`.cursor/rules/`) — Development policies and coding standards
- **Claude Skills** (`/skills/`) — Step-by-step execution guides
- **Terminal & SSH Policy** — Safe automation guidelines
- **Helper Scripts** — Apply policies to any project

**Portable**, **project-agnostic**, and designed for both **Cursor IDE** and **Claude Code CLI**.

## 🚀 Quick Start

### Option 1: Use with Cursor IDE
```bash
# Clone this repository
git clone https://github.com/yourorg/Policies-Instructions-and-Skills.git

# Copy rules to your project
cp -r Policies-Instructions-and-Skills/.cursor/rules /path/to/your-project/.cursor/

# Cursor automatically loads rules!
```

### Option 2: Use with Claude Code CLI
```bash
# Reference in your conversation
"Follow policies from /path/to/Policies-Instructions-and-Skills"

# Or copy specific skills
cat Policies-Instructions-and-Skills/skills/api-express/skill.md
# [paste into Claude Code conversation]
```

### Option 3: Use Helper Script
```bash
# Automated copy with prompts
./Policies-Instructions-and-Skills/scripts/apply-policies.sh /path/to/your-project
```

## 📚 What's Included?

### Cursor Rules (Policies)
10+ modular rules covering:
- ✅ JavaScript/ES6+ code style
- ✅ React UI, SCSS, accessibility
- ✅ RTL & Hebrew-first design
- ✅ Tables, forms, data patterns
- ✅ Express API, REST conventions
- ✅ Auth & RBAC (JWT, roles)
- ✅ Prisma + PostgreSQL
- ✅ Testing (unit, integration, E2E)
- ✅ Git workflow & commits
- ✅ Security & secrets handling

[Browse all rules →](./.cursor/rules/)

### Claude Skills (Execution)
9+ skills for common tasks:
- 🔧 UI components (React, SCSS, a11y)
- 📊 Data tables (sortable, filterable)
- 🌐 RTL/Hebrew implementation
- 🔌 API endpoints (Express, REST)
- 🔐 Auth & RBAC setup
- 💾 Database operations (Prisma)
- 🧪 Testing workflows
- 🚀 CI/CD pipelines
- 💻 Terminal & SSH operations

[Browse all skills →](./skills/)

### Documentation
- [Usage with Cursor](./docs/USAGE_WITH_CURSOR.md)
- [Usage with Claude Code](./docs/USAGE_WITH_CLAUDE_CODE.md)
- [Architecture of Policies](./docs/ARCHITECTURE_OF_POLICIES.md)
- [Terminal & SSH Policy](./docs/ops/TERMINAL_SSH_POLICY.md)
- [Agent Instructions (Codex/Claude/Gemini)](./docs/ops/agent-instructions/)
- [Contributing](./docs/CONTRIBUTING.md)

## 💡 How It Works

```
┌────────────────────────────────────┐
│       User Request                  │
│  "Add user authentication"         │
└────────────┬───────────────────────┘
             │
    ┌────────┴────────┐
    ↓                 ↓
  RULES            SKILLS
(What/Why)       (How/Steps)
    │                 │
    │  Policy:        │  Execute:
    │  - Use bcrypt   │  1. Install bcrypt
    │  - JWT tokens   │  2. Create hash util
    │  - RBAC roles   │  3. Add JWT logic
    │                 │  4. Protect routes
    │                 │  5. Write tests
    └────────┬────────┘
             ↓
     ✅ Complete Implementation
```

**Rules** define constraints → **Skills** execute steps → **Result** follows both.

## 📖 Examples

### Example 1: Adding an API Endpoint
```markdown
# User to AI:
"Add a new API endpoint for products"

# AI process:
1. Reads: .cursor/rules/050-api-express.md (policy)
2. Follows: skills/api-express/skill.md (steps)
3. Creates:
   - routes/products.routes.js
   - controllers/products.controller.js
   - validation/products.validation.js
   - Tests

# Result: RESTful endpoint following all policies
```

### Example 2: RTL Layout
```markdown
# User to AI:
"Make this component RTL-compatible"

[Pastes: skills/rtl-hebrew/skill.md]

# AI process:
1. Reads: .cursor/rules/030-rtl-hebrew.md
2. Converts to logical CSS properties
3. Handles mixed LTR/RTL content
4. Adds i18n support
5. Tests in RTL mode

# Result: Fully RTL-compatible component
```

## 🛠️ Repository Structure

```
Policies-Instructions-and-Skills/
├── .cursor/rules/          # Cursor Rules (policies)
│   ├── 000-overview.md
│   ├── 010-code-style-js.md
│   ├── 020-ui-react-scss-a11y.md
│   ├── 030-rtl-hebrew.md
│   ├── 040-tables-forms.md
│   ├── 050-api-express.md
│   ├── 060-auth-rbac.md
│   ├── 070-prisma-postgres.md
│   ├── 080-testing-e2e.md
│   ├── 090-git-workflow.md
│   └── 100-security-secrets.md
│
├── skills/                 # Claude Skills (execution)
│   ├── 00-template/
│   ├── ui/
│   ├── tables/
│   ├── rtl-hebrew/
│   ├── api-express/
│   ├── auth-rbac/
│   ├── prisma-postgres/
│   ├── testing-e2e/
│   ├── ci-cd/
│   └── terminal-ssh-vps/
│
├── docs/                   # Documentation
│   ├── USAGE_WITH_CURSOR.md
│   ├── USAGE_WITH_CLAUDE_CODE.md
│   ├── ARCHITECTURE_OF_POLICIES.md
│   ├── CONTRIBUTING.md
│   └── ops/
│       └── TERMINAL_SSH_POLICY.md
│
├── scripts/                # Helper scripts
│   ├── apply-policies.sh
│   └── apply-policies.ps1
│
├── RULES_CURSOR.md        # Root rules summary
├── README.md              # This file
└── .editorconfig          # Editor configuration
```

## 🌟 Key Features

### Hebrew-First & RTL
All policies include explicit RTL support:
- Logical CSS properties
- Hebrew typography
- Mixed content handling (emails, URLs in RTL context)
- Bidirectional text markers

### Autonomous AI Operation
Rules instruct AI assistants to:
- ✅ Proceed without endless questions
- ✅ Use sensible defaults
- ✅ Only ask for critical blockers
- ✅ Document assumptions

### Safety-First Terminal Operations
Terminal & SSH Policy ensures:
- ⚠️ Confirmation before destructive ops
- 🔒 Never echo secrets
- 📝 Redacted logging
- ✅ Safe automation guidelines

### Copy/Paste Friendly
- **Rules**: Comprehensive reference (300-1000+ lines)
- **Skills**: Concise execution (120-250 lines)
- **Details**: Deep dives available on demand

## 🤝 Contributing

We welcome contributions! See [CONTRIBUTING.md](./docs/CONTRIBUTING.md) for:
- Adding new rules
- Creating new skills
- Improving documentation
- Reporting issues

## 📄 License

[MIT License](./LICENSE)

## 🔗 Resources

- [Cursor IDE](https://cursor.sh/) — AI-powered code editor
- [Claude Code](https://github.com/anthropics/claude-code) — Claude CLI for development
- [Conventional Commits](https://www.conventionalcommits.org/) — Commit message standard

## 🙏 Acknowledgments

- Designed for real-world development workflows
- Hebrew/RTL-first approach
- Safety-conscious automation
- Project-agnostic and portable

---

**Built for developers by developers**

**Questions?** See [docs/README.md](./docs/README.md) or open an issue.

**Last Updated**: 2025-12-31
