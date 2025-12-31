# Claude Skills Library

## What Are Skills?

**Skills** are step-by-step execution guides designed to be pasted into an LLM (like Claude) to perform specific development tasks. Each skill follows a consistent structure:

- **Short `skill.md`** (120–250 lines) — Copy this into your LLM prompt
- **Deep `details/`** directory — Reference documentation with examples, checklists, and anti-patterns

## How to Use Skills

### 1. Copy the Short Skill File
When you need to perform a task, copy the relevant `skill.md` into your LLM conversation:

```
I need to add a new API endpoint for managing products.

Here's the skill to follow:
[paste contents of skills/api-express/skill.md]
```

### 2. LLM Follows the Steps
The LLM will:
1. Read the skill instructions
2. Access the details files for deeper context (if needed)
3. Execute the steps autonomously
4. Provide output and documentation

### 3. Refer to Details for Context
The `details/` directory provides:
- **README.md** — Comprehensive guide with theory and patterns
- **examples.md** — Real-world code examples
- **checklist.md** — Definition of done / acceptance criteria
- **anti-patterns.md** — What to avoid and why

## Available Skills

### [00-template](./00-template/skill.md)
Template for creating new skills. Use this as a starting point for custom skills.

### [ui](./ui/skill.md)
**Purpose**: Implement UI components with React, SCSS, and accessibility

**When to use**:
- Creating new React components
- Adding interactive UI elements
- Implementing forms or modals
- Building responsive layouts

**Outputs**: React component files, SCSS stylesheets, tests

---

### [tables](./tables/skill.md)
**Purpose**: Build sortable, filterable, paginated data tables

**When to use**:
- Displaying lists of data
- Adding sorting/filtering/search
- Implementing pagination
- Creating data grids

**Outputs**: Table component, pagination logic, filter controls

---

### [rtl-hebrew](./rtl-hebrew/skill.md)
**Purpose**: Implement RTL layout and Hebrew-first UI

**When to use**:
- Starting a new Hebrew/RTL project
- Converting LTR UI to RTL
- Handling mixed LTR/RTL content
- Debugging RTL layout issues

**Outputs**: RTL-aware components, i18n setup, language switcher

---

### [api-express](./api-express/skill.md)
**Purpose**: Create RESTful API endpoints with Express

**When to use**:
- Adding new API routes
- Implementing CRUD operations
- Setting up validation and error handling
- Building REST APIs

**Outputs**: Route files, controller functions, validation schemas

---

### [auth-rbac](./auth-rbac/skill.md)
**Purpose**: Implement authentication and role-based access control

**When to use**:
- Setting up user authentication
- Implementing login/register/logout
- Adding role-based permissions
- Protecting routes and content

**Outputs**: Auth middleware, JWT logic, protected routes, RBAC system

---

### [prisma-postgres](./prisma-postgres/skill.md)
**Purpose**: Work with Prisma ORM and PostgreSQL database

**When to use**:
- Creating or modifying database schema
- Writing database migrations
- Implementing CRUD operations
- Seeding test data

**Outputs**: Prisma schema, migrations, seed files, database queries

---

### [testing-e2e](./testing-e2e/skill.md)
**Purpose**: Write unit, integration, and E2E tests

**When to use**:
- Adding tests for new features
- Testing API endpoints
- Creating E2E user flow tests
- Setting up test infrastructure

**Outputs**: Test files (Vitest, Playwright), test configuration

---

### [ci-cd](./ci-cd/skill.md)
**Purpose**: Set up continuous integration and deployment pipelines

**When to use**:
- Configuring GitHub Actions / GitLab CI
- Automating tests and builds
- Setting up deployment workflows
- Implementing automated releases

**Outputs**: CI/CD configuration files, workflow definitions

---

### [terminal-ssh-vps](./terminal-ssh-vps/skill.md)
**Purpose**: Safe terminal operations and SSH usage for VPS management

**When to use**:
- Running terminal commands safely
- SSH operations on remote servers
- Managing services on VPS
- Deploying applications

**Outputs**: Executed commands, deployment logs, service configurations

**⚠️ Important**: This skill includes safety guidelines. Always review commands before execution.

---

## Skill Structure

Each skill follows this consistent structure:

```
skills/
└── {skill-name}/
    ├── skill.md                    # SHORT (120-250 lines) - Copy/paste this
    └── details/
        ├── README.md               # Deep dive: theory, patterns, best practices
        ├── examples.md             # Code examples and real-world scenarios
        ├── checklist.md            # Acceptance criteria / definition of done
        └── anti-patterns.md        # Common mistakes and what to avoid
```

### skill.md Format
```markdown
# [Skill Name]

## Purpose
Brief description of what this skill does.

## When to Use
Situations where this skill applies.

## Required Inputs
What information is needed to execute this skill.

## Steps
1. [Step 1]
2. [Step 2]
...

## Expected Outputs
What will be created/modified.

## Validation
How to verify success.

## Links to Details
- [Deep Documentation](./details/README.md)
- [Examples](./details/examples.md)
- [Checklist](./details/checklist.md)
- [Anti-Patterns](./details/anti-patterns.md)
```

## Creating Custom Skills

Use the [template skill](./00-template/skill.md) as a starting point:

1. Copy `00-template/` to a new directory: `skills/my-custom-skill/`
2. Edit `skill.md` with your specific steps
3. Fill in the `details/` files with deep documentation
4. Keep `skill.md` short (120–250 lines) for copy/paste efficiency
5. Put comprehensive docs in `details/README.md`

## Relationship to Cursor Rules

- **Cursor Rules** (`.cursor/rules/`) define **policies** — what and why
- **Skills** (`/skills/`) define **execution** — step-by-step how

Example:
- **Rule**: `.cursor/rules/050-api-express.md` — API design policies
- **Skill**: `/skills/api-express/skill.md` — How to implement an API endpoint

Both work together:
1. AI reads the rule to understand constraints
2. AI executes the skill to perform the task
3. Result follows both policy and implementation pattern

## Best Practices

### ✅ DO
- Keep `skill.md` concise and actionable
- Include validation steps
- Link to related rules and skills
- Provide clear expected outputs
- Include safety warnings (e.g., destructive operations)

### ❌ DON'T
- Don't make skills too specific (keep them reusable)
- Don't include secrets or credentials in examples
- Don't skip validation steps
- Don't create overlapping skills (consolidate instead)

## Contributing

See [/docs/CONTRIBUTING.md](/docs/CONTRIBUTING.md) for guidelines on:
- Creating new skills
- Updating existing skills
- Maintaining consistency

---

**Related**: [Cursor Rules](../.cursor/rules/) | [Policies Architecture](/docs/ARCHITECTURE_OF_POLICIES.md)

**Last Updated**: 2025-12-31
