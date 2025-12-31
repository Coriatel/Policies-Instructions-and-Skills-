# Architecture of Policies — How Rules and Skills Work Together

## Overview

This repository contains two complementary systems:

1. **Cursor Rules** (`.cursor/rules/`) — **Policies**: What and Why
2. **Claude Skills** (`/skills/`) — **Execution**: How (step-by-step)

Together, they provide both the constraints (rules) and the processes (skills) for consistent software development.

## The Two-Layer Architecture

```
┌─────────────────────────────────────────┐
│          User Request                    │
│    "Add a new API endpoint"             │
└──────────────┬──────────────────────────┘
               │
               ├──> Layer 1: RULES (Policy/Constraints)
               │    │
               │    ├─> .cursor/rules/050-api-express.md
               │    │   - REST conventions
               │    │   - Error handling patterns
               │    │   - Security requirements
               │    │   - Validation approach
               │    │
               │    └─> .cursor/rules/100-security-secrets.md
               │        - Input sanitization
               │        - Rate limiting
               │        - CORS policy
               │
               └──> Layer 2: SKILLS (Execution/Process)
                    │
                    └─> skills/api-express/skill.md
                        Step 1: Create route file
                        Step 2: Create controller
                        Step 3: Add validation schema
                        Step 4: Update main router
                        Step 5: Write tests
                        Step 6: Test with curl
                        ✅ Validation: All tests pass

Result: API endpoint that follows policies and is implemented correctly
```

## Layer 1: Cursor Rules (Policies)

### Purpose
Define **what** should be done and **why** it matters.

### Characteristics
- **Declarative**: "Use bcrypt for password hashing"
- **Comprehensive**: Covers all scenarios
- **Reference material**: To be read and understood
- **Project-agnostic**: No specific project names/paths

### Example Rule
```markdown
<!-- .cursor/rules/060-auth-rbac.md -->
# Authentication & RBAC

## Password Security
### Hashing
✅ DO: Use bcrypt with 10 salt rounds
❌ DON'T: Store passwords in plain text
❌ DON'T: Use MD5 or SHA1 for passwords

[Comprehensive examples and patterns...]
```

### When AI Uses Rules
- Before starting any task
- To understand constraints and requirements
- To validate approach
- To check if solution meets standards

## Layer 2: Claude Skills (Execution)

### Purpose
Define **how** to execute a specific task, step-by-step.

### Characteristics
- **Imperative**: "Step 1: Run this command"
- **Task-specific**: Focused on one type of work
- **Action-oriented**: Designed for execution
- **Copy/paste friendly**: Short, concise (120-250 lines)

### Example Skill
```markdown
<!-- skills/auth-rbac/skill.md -->
# Auth & RBAC Skill

## Steps

### 1. Install Dependencies
```bash
npm install bcrypt jsonwebtoken
```

### 2. Create Hashing Utility
Create `utils/hash.js`:
[specific code...]

### 3. Generate JWT Tokens
Create `utils/jwt.js`:
[specific code...]

[...more specific steps...]

## Validation
- [ ] Run tests: `npm test`
- [ ] Passwords are hashed
- [ ] Tokens expire correctly
```

### When AI Uses Skills
- When user requests specific task
- As step-by-step execution guide
- To ensure completeness
- To validate implementation

## How They Work Together

### Scenario 1: Adding User Authentication

**User Request**: "Add user authentication to the app"

**Step 1 — AI Reads Rules**:
- `.cursor/rules/060-auth-rbac.md` → Policy: Use JWT, bcrypt, short-lived tokens
- `.cursor/rules/100-security-secrets.md` → Policy: Store secrets in .env, never hardcode
- `.cursor/rules/050-api-express.md` → Policy: Use Joi validation, proper error handling

**Step 2 — AI Executes Skill**:
- `skills/auth-rbac/skill.md` → Process:
  1. Install bcrypt, jsonwebtoken
  2. Create hash utility
  3. Create JWT utility
  4. Implement login endpoint
  5. Create auth middleware
  6. Protect routes
  7. Write tests
  8. Validate

**Result**: Authentication system that:
- ✅ Uses bcrypt with 10 rounds (from rule)
- ✅ Has short-lived access tokens (from rule)
- ✅ Stores secrets in .env (from rule)
- ✅ Follows all implementation steps (from skill)
- ✅ Has proper validation (from rule + skill)
- ✅ Has tests (from skill)

### Scenario 2: Building a Data Table

**User Request**: "Create a sortable users table"

**Step 1 — AI Reads Rules**:
- `.cursor/rules/040-tables-forms.md` → Policy: Pagination, accessibility, empty states
- `.cursor/rules/030-rtl-hebrew.md` → Policy: RTL layout, logical properties
- `.cursor/rules/020-ui-react-scss-a11y.md` → Policy: Semantic HTML, ARIA labels

**Step 2 — AI Executes Skill**:
- `skills/tables/skill.md` → Process:
  1. Create table component
  2. Implement sorting logic
  3. Add pagination
  4. Add filter/search
  5. Style for RTL
  6. Add accessibility attributes
  7. Handle loading/error states
  8. Write tests

**Result**: Data table that:
- ✅ Sorts and paginates (from skill)
- ✅ Works in RTL (from rule)
- ✅ Is accessible (from rule)
- ✅ Has empty states (from rule)
- ✅ Follows all steps (from skill)

## Information Flow

```
User → AI Agent
          ↓
    ┌─────┴─────┐
    ↓           ↓
  RULES      SKILLS
 (What/Why) (How/Steps)
    ↓           ↓
    └─────┬─────┘
          ↓
   Implementation
   (Code follows policy + process)
```

## File Organization

```
Policies-Instructions-and-Skills/
├── .cursor/rules/              # LAYER 1: POLICIES
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
├── skills/                     # LAYER 2: EXECUTION
│   ├── ui/skill.md
│   ├── tables/skill.md
│   ├── rtl-hebrew/skill.md
│   ├── api-express/skill.md
│   ├── auth-rbac/skill.md
│   ├── prisma-postgres/skill.md
│   ├── testing-e2e/skill.md
│   ├── ci-cd/skill.md
│   └── terminal-ssh-vps/skill.md
│
└── docs/                       # SUPPORTING DOCUMENTATION
    ├── USAGE_WITH_CURSOR.md
    ├── USAGE_WITH_CLAUDE_CODE.md
    ├── ARCHITECTURE_OF_POLICIES.md (this file)
    ├── CONTRIBUTING.md
    └── ops/
        └── TERMINAL_SSH_POLICY.md
```

## Design Principles

### Rules Should Be
- **Comprehensive**: Cover all scenarios
- **Timeless**: Rarely change
- **Reference**: Read to understand
- **Modular**: One concern per file

### Skills Should Be
- **Focused**: One task
- **Actionable**: Clear steps
- **Concise**: 120-250 lines
- **Executable**: Can be followed directly

### Both Should Be
- **Project-agnostic**: No hardcoded names
- **Well-linked**: Reference each other
- **Example-rich**: Show, don't just tell
- **Maintained**: Updated as needed

## When to Use What

### Use Rules When:
- Setting project standards
- Defining security requirements
- Establishing code style
- Documenting architecture decisions
- Creating reusable policies

### Use Skills When:
- Executing a specific task
- Providing step-by-step guide
- Onboarding new developers
- Automating with AI
- Ensuring task completeness

### Use Both When:
- Building new features (rule = what, skill = how)
- Code review (rule = standards, skill = implementation)
- Refactoring (rule = target state, skill = process)
- Training AI (rule = constraints, skill = execution)

## Benefits of This Architecture

### For Developers
- **Clear standards** from rules
- **Concrete steps** from skills
- **Consistency** across projects
- **Faster onboarding**

### For AI Assistants
- **Constraints** from rules prevent mistakes
- **Process** from skills ensure completeness
- **Context** from both improves output
- **Validation** from both confirms success

### For Projects
- **Reusable** across multiple projects
- **Maintainable** (update once, apply everywhere)
- **Scalable** (add rules/skills as needed)
- **Portable** (copy to any project)

## See Also

- [Cursor Rules Overview](../.cursor/rules/000-overview.md)
- [Skills README](/skills/README.md)
- [Usage with Cursor](/docs/USAGE_WITH_CURSOR.md)
- [Usage with Claude Code](/docs/USAGE_WITH_CLAUDE_CODE.md)

---

**Last Updated**: 2025-12-31
