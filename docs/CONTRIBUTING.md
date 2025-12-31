# Contributing to the Development Policy Library

Thank you for your interest in improving this library! This document provides guidelines for contributing.

## How to Contribute

### 1. Report Issues
- Found a mistake in a rule or skill?
- Have a suggestion for improvement?
- Want to request a new rule or skill?

Open an issue on GitHub with details.

### 2. Improve Existing Rules
- Fix typos or unclear explanations
- Add better examples
- Update outdated information
- Enhance documentation

### 3. Create New Rules
See "Adding New Rules" below.

### 4. Create New Skills
See "Adding New Skills" below.

## Guidelines

### General Principles
- **Keep it project-agnostic**: No hardcoded project names or paths
- **Be comprehensive**: Cover edge cases and anti-patterns
- **Show examples**: Code examples are better than descriptions
- **Link related content**: Reference other rules and skills
- **Stay focused**: One concern per file

## Adding New Rules

### 1. Determine the Category
Rules are numbered by category:
- 000-099: Meta (overview, how-to-use)
- 100-199: Code style and conventions
- 200-299: UI/UX patterns
- 300-399: Backend/API patterns
- 400-499: Database and data patterns
- 500-599: Testing patterns
- 600-699: DevOps/deployment
- 700-799: Security
- 800-899: Workflow (git, etc.)
- 900-999: Project-specific overrides

### 2. Create the File
```bash
# Use next available number in category
touch .cursor/rules/XXX-your-rule-name.md
```

### 3. Follow the Template
```markdown
# Rule Title — Subtitle

## Section 1

### Subsection
```code
// ✅ DO: Example of correct approach
```

```code
// ❌ DON'T: Example of anti-pattern
```

## Related
- [Related Rule](./XXX-related.md)
- [Related Skill](/skills/related/skill.md)
```

### 4. Requirements
- [ ] Clear title and purpose
- [ ] ✅/❌ examples for key concepts
- [ ] Code examples (not just prose)
- [ ] Links to related rules and skills
- [ ] "Last Updated" date
- [ ] No secrets or credentials in examples

## Adding New Skills

### 1. Create Directory Structure
```bash
mkdir -p skills/my-skill/details
```

### 2. Create Required Files
Every skill needs these 5 files:

#### skill.md (SHORT, 120-250 lines)
```markdown
# Skill Title

## Purpose
[What this skill accomplishes]

## When to Use
- [Scenario 1]
- [Scenario 2]

## Required Inputs
- **Input 1**: Description

## Steps

### 1. First Step
[Detailed instructions]

### 2. Second Step
[Detailed instructions]

[... more steps ...]

## Expected Outputs
- [ ] Output 1
- [ ] Output 2

## Validation
- [ ] Check 1
- [ ] Check 2

## Links
- [Details](./details/README.md)
- [Examples](./details/examples.md)
- [Checklist](./details/checklist.md)
- [Anti-Patterns](./details/anti-patterns.md)
```

#### details/README.md (COMPREHENSIVE)
Deep documentation with theory, patterns, alternatives.

#### details/examples.md (CODE-HEAVY)
5-10 real code examples with explanations.

#### details/checklist.md (ACCEPTANCE CRITERIA)
Clear definition of done.

#### details/anti-patterns.md (MISTAKES)
Common mistakes with ❌/✅ examples.

### 3. Requirements
- [ ] skill.md is 120-250 lines (concise)
- [ ] All 5 files created
- [ ] Steps are numbered and actionable
- [ ] Validation steps included
- [ ] Links to related Cursor Rules
- [ ] Examples are realistic
- [ ] No secrets in code examples

## Pull Request Process

### 1. Fork and Branch
```bash
git clone https://github.com/yourorg/Policies-Instructions-and-Skills.git
cd Policies-Instructions-and-Skills
git checkout -b feature/add-graphql-rule
```

### 2. Make Changes
- Follow guidelines above
- Test examples if possible
- Update related documentation

### 3. Commit
```bash
git add .
git commit -m "feat(rules): add GraphQL API patterns"
```

Use [Conventional Commits](https://www.conventionalcommits.org/):
- `feat:` new rule or skill
- `fix:` correction
- `docs:` documentation only
- `refactor:` reorganization without behavior change

### 4. Submit PR
- Clear title and description
- Reference any related issues
- Explain motivation and changes
- Include examples if applicable

## Review Criteria

PRs will be reviewed for:
- [ ] Follows guidelines in this document
- [ ] No hardcoded project-specific content
- [ ] Examples are clear and correct
- [ ] Links work and are relevant
- [ ] No secrets or credentials
- [ ] Proper formatting and spelling
- [ ] Adds value to the library

## Style Guide

### Markdown
- Use ATX headers (`#`, `##`, not underlines)
- Code blocks have language specified: ` ```javascript`
- Use ✅/❌ for do/don't examples
- Use `[ ]` for checklists

### Code Examples
```javascript
// ✅ DO: Clear, working example
const user = await prisma.user.findUnique({
  where: { id },
});

// ❌ DON'T: Anti-pattern with explanation
const user = await db.query(`SELECT * FROM users WHERE id = '${id}'`); // SQL injection!
```

### File Naming
- Rules: `NNN-kebab-case-name.md`
- Skills: `kebab-case-name/`
- No spaces, underscores, or special characters

## Testing

### Rules
- Read through to ensure clarity
- Verify all links work
- Check code examples compile/run

### Skills
- Follow the skill steps yourself
- Verify outputs match expectations
- Test validation steps

## Questions?

- Open an issue for questions
- Tag with `question` label
- We'll respond and may add FAQ section

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

**Thank you for contributing!**

**Last Updated**: 2025-12-31
