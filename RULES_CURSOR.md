# Cursor Rules — Development Policy Library

This is a modular, reusable set of Cursor Rules for consistent software development practices. These rules work with both Cursor IDE and Claude Code.

## 📚 Rules Overview

All rules are organized in [`.cursor/rules/`](./.cursor/rules/) for easy integration:

### [000 — Overview](./.cursor/rules/000-overview.md)
- How to use these rules in your project
- Integration with Claude Skills
- Customization guidelines

### [010 — Code Style (JavaScript)](./.cursor/rules/010-code-style-js.md)
- Modern ES6+ patterns
- Naming conventions
- Code formatting with Prettier
- ESLint configuration
- PropTypes for React (non-TypeScript projects)

### [020 — UI (React, SCSS, Accessibility)](./.cursor/rules/020-ui-react-scss-a11y.md)
- Functional components with hooks
- SCSS/BEM conventions
- Accessibility (a11y) requirements
- Loading, error, and empty states
- Performance optimization (React.memo, lazy loading)

### [030 — RTL & Hebrew-First UI](./.cursor/rules/030-rtl-hebrew.md)
- RTL layout implementation
- Hebrew typography and fonts
- Handling mixed LTR/RTL content
- Tables and forms in RTL
- Internationalization (i18n) with react-i18next

### [040 — Tables & Forms](./.cursor/rules/040-tables-forms.md)
- Sortable, filterable, paginated tables
- Form validation patterns
- Accessibility requirements
- Empty states and loading indicators

### [050 — API (Express, REST)](./.cursor/rules/050-api-express.md)
- RESTful API design patterns
- Express server structure
- Route organization
- Validation with Joi
- Error handling middleware
- Security (rate limiting, input sanitization)

### [060 — Auth & RBAC](./.cursor/rules/060-auth-rbac.md)
- JWT authentication (access + refresh tokens)
- Password hashing with bcrypt
- Role-based access control (RBAC)
- Content visibility filtering
- Protected routes (frontend + backend)

### [070 — Database (Prisma + PostgreSQL)](./.cursor/rules/070-prisma-postgres.md)
- Prisma ORM setup and configuration
- CRUD operations and advanced queries
- Migrations and seeding
- Transactions and performance optimization
- Connection pooling

### [080 — Testing (Unit, Integration, E2E)](./.cursor/rules/080-testing-e2e.md)
- Unit testing with Vitest
- Integration testing (API endpoints)
- E2E testing with Playwright
- Testing RBAC and auth flows
- Coverage goals and best practices

### [090 — Git Workflow](./.cursor/rules/090-git-workflow.md)
- Conventional Commits format
- Branching strategy (feature/fix/hotfix)
- Pull request guidelines
- Common git commands
- .gitignore template

### [100 — Security & Secrets](./.cursor/rules/100-security-secrets.md)
- Environment variables management
- Password security (hashing, requirements)
- JWT security
- Input validation and sanitization
- HTTPS, secure cookies, CORS
- Rate limiting and security headers
- Logging without exposing secrets
- Hosting provider compliance (Hostinger & similar)

### [110 — Hostinger VPS Compliance](./.cursor/rules/110-hostinger-vps-compliance.md)
- Hostinger Terms of Service compliance
- VPS security requirements and suspension risk model
- Defensive security only (no offensive tools)
- AI agent safety protocols
- Malware prevention and response
- Provider communication guidelines

## 🚀 Quick Start

### Option 1: Copy Rules to Your Project
```bash
# Clone or download this repository
git clone https://github.com/yourorg/policies-instructions-skills.git

# Copy .cursor/rules/ to your project
cp -r policies-instructions-skills/.cursor/rules/ /path/to/your-project/.cursor/

# Or use the helper script
./policies-instructions-skills/scripts/apply-policies.sh /path/to/your-project
```

### Option 2: Create a Single .cursorrules File
If you prefer a single file, you can combine the modular rules:

```bash
# In your project root
cat .cursor/rules/*.md > .cursorrules
```

### Option 3: Link to This Repo
Add a reference in your project's README:

```markdown
# Development Policies

This project follows the policies defined in:
https://github.com/yourorg/policies-instructions-skills
```

## 🔧 Customization

These rules are intentionally project-agnostic. To customize:

1. **Copy to your project** — Start with these rules as a baseline
2. **Add project-specific rules** — Create `.cursor/rules/110-project-specifics.md`
3. **Override defaults** — Create `.cursor/rules/999-overrides.md`

Example override:
```markdown
# Project-Specific Overrides

## TypeScript Instead of JavaScript
This project uses TypeScript. Follow the patterns in `010-code-style-js.md`
but apply them to `.ts` and `.tsx` files.
```

## 🤖 AI Assistant Instructions

When using these rules with Cursor or Claude Code:

### Autonomous Operation
- **Proceed without endless questions** — Use sensible defaults
- **Only ask when blocked** — Destructive actions, secrets, or critical decisions
- **Document assumptions** — Make your reasoning transparent

### Integration with Skills
These rules define **what** and **why**. The [Skills Library](/skills/README.md) defines **how** (step-by-step).

Example workflow:
1. User: "Add a new API endpoint"
2. AI reads: `.cursor/rules/050-api-express.md` (policy)
3. AI executes: `/skills/api-express/skill.md` (implementation steps)

## 📖 Related Documentation

- [Skills Library](/skills/README.md) — Step-by-step implementation guides
- [Usage with Cursor](/docs/USAGE_WITH_CURSOR.md) — Integration guide for Cursor IDE
- [Usage with Claude Code](/docs/USAGE_WITH_CLAUDE_CODE.md) — CLI integration guide
- [Architecture of Policies](/docs/ARCHITECTURE_OF_POLICIES.md) — How rules and skills work together
- [Terminal & SSH Policy](/docs/ops/TERMINAL_SSH_POLICY.md) — Safe automation guidelines
- [Contributing](/docs/CONTRIBUTING.md) — How to extend this library

## 🎯 Philosophy

### Hebrew-First & RTL
All rules and skills address RTL layout, Hebrew typography, and mixed content handling with concrete examples.

### Definition of Done
Each rule category includes:
- ✅ Clear acceptance criteria
- 🚫 Anti-patterns to avoid
- 📝 Concrete examples
- 🔗 Links to related resources

### Copy/Paste Friendly
Rules are designed to be:
- **Modular** — One concern per file
- **Portable** — No hardcoded project names
- **Actionable** — Clear do's and don'ts
- **Practical** — Real-world examples

## 📦 Repository Structure

```
.
├── .cursor/
│   └── rules/              # Modular Cursor Rules
├── skills/                 # Claude Skills Library
│   ├── ui/
│   ├── tables/
│   ├── rtl-hebrew/
│   ├── api-express/
│   ├── auth-rbac/
│   ├── prisma-postgres/
│   ├── testing-e2e/
│   ├── ci-cd/
│   ├── terminal-ssh-vps/
│   └── hostinger-vps-ops/
├── docs/                   # Documentation
│   ├── USAGE_WITH_CURSOR.md
│   ├── USAGE_WITH_CLAUDE_CODE.md
│   ├── ARCHITECTURE_OF_POLICIES.md
│   ├── CONTRIBUTING.md
│   ├── PROMPTS_LIBRARY.md
│   └── ops/
│       ├── TERMINAL_SSH_POLICY.md
│       ├── HOSTINGER_VPS_RUNBOOK.md
│       ├── HOSTINGER_SECURITY_BASELINE_UBUNTU.md
│       ├── HOSTINGER_MALWARE_RESPONSE.md
│       ├── HOSTINGER_WORDPRESS_HARDENING.md
│       └── HOSTINGER_AI_AGENT_SAFETY.md
├── scripts/                # Helper scripts
│   ├── apply-policies.sh
│   └── apply-policies.ps1
├── RULES_CURSOR.md         # This file
└── README.md               # Project overview
```

## 🤝 Contributing

See [CONTRIBUTING.md](/docs/CONTRIBUTING.md) for guidelines on:
- Adding new rules
- Updating existing rules
- Creating new skills
- Maintaining consistency

## 📄 License

MIT License — See LICENSE file for details

---

**Last Updated**: 2025-12-31
**Maintained by**: Development Policy Library Project
**For Questions**: See [docs/README.md](/docs/README.md)
