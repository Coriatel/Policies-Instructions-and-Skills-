# Documentation

Welcome to the CRM Platform documentation! This directory contains comprehensive guides for development, deployment, and architecture.

## Quick Start

- **New to the project?** → Start with `/skills/getting-started.md`
- **Want to contribute?** → Read `DEVELOPMENT.md`
- **Understanding the codebase?** → Check `ARCHITECTURE.md`
- **Deploying to production?** → See `DEPLOYMENT.md`

## Documentation Structure

### Core Docs
- **README.md** (this file) - Documentation index
- **ARCHITECTURE.md** - System design and architecture
- **DEVELOPMENT.md** - Development workflow and best practices
- **API.md** - API reference and examples
- **DEPLOYMENT.md** - Production deployment guide
- **SECURITY.md** - Security guidelines
- **ASSUMPTIONS.md** - Design decisions and assumptions

### Skills
Located in `/skills/` - Quick reference guides for common tasks:
- Getting Started
- Adding API Routes
- Adding React Pages
- Database Migrations
- RBAC Setup
- Testing
- Deployment

## Technology Stack

### Frontend
- **React 18** - UI library
- **Vite** - Build tool
- **React Router v6** - Routing
- **SCSS** - Styling (RTL-first)
- **i18next** - Internationalization
- **Axios** - HTTP client

### Backend
- **Node.js 18+** - Runtime
- **Express** - Web framework
- **Prisma** - ORM for PostgreSQL
- **Mongoose** - MongoDB adapter
- **JWT** - Authentication
- **Bcrypt** - Password hashing

### Databases
- **PostgreSQL 15** - Primary database (users, content, audit logs)
- **MongoDB 6** - Activity logs (minimal usage)

### Testing
- **Vitest** - Unit testing
- **React Testing Library** - Component testing
- **Playwright** - E2E testing

### DevOps
- **Docker Compose** - Local development
- **GitHub Actions** - CI/CD
- **ESLint + Prettier** - Code quality

## Project Structure

```
├── apps/
│   ├── api/              # Express API
│   │   ├── src/
│   │   │   ├── routes/
│   │   │   ├── controllers/
│   │   │   ├── middleware/
│   │   │   ├── validation/
│   │   │   └── config/
│   │   └── tests/
│   └── web/              # React app
│       ├── src/
│       │   ├── pages/
│       │   ├── components/
│       │   ├── context/
│       │   ├── guards/
│       │   ├── utils/
│       │   ├── styles/
│       │   └── locales/
│       └── tests/
├── packages/
│   └── shared/           # Shared code (validation, constants)
├── prisma/
│   ├── postgres/         # PostgreSQL schema + migrations
│   └── mongo/            # MongoDB models
├── e2e/                  # Playwright E2E tests
├── skills/               # Quick reference guides
├── docs/                 # Comprehensive documentation
└── docker-compose.yml    # Local dev environment
```

## Key Concepts

### Role-Based Access Control (RBAC)
- **Roles**: ADMIN, MALE, FEMALE
- **Content Visibility**: PUBLIC, MALE_ONLY, FEMALE_ONLY, ADMIN_ONLY
- Enforced on both API and UI levels

### RTL Support
- Hebrew is the primary language (RTL layout)
- English available as secondary language
- All UI text managed through i18n

### Authentication
- JWT-based with access + refresh tokens
- Access token: 15 min expiry
- Refresh token: 7 day expiry
- Password requirements: min 8 chars, 1 uppercase, 1 number

## Common Commands

```bash
# Install dependencies
npm install

# Start development
npm run dev

# Run tests
npm test
npm run test:e2e

# Database operations
npm run db:migrate --workspace=apps/api
npm run db:seed --workspace=apps/api
npm run db:studio --workspace=apps/api

# Linting and formatting
npm run lint
npm run format

# Build for production
npm run build
```

## Environment Setup

1. Copy `.env.example` files:
   ```bash
   cp apps/api/.env.example apps/api/.env
   ```

2. Start databases:
   ```bash
   docker-compose up -d
   ```

3. Run migrations:
   ```bash
   npm run db:migrate --workspace=apps/api
   npm run db:seed --workspace=apps/api
   ```

4. Start dev servers:
   ```bash
   npm run dev
   ```

## Test Accounts

After seeding the database:

- **Admin**: `admin@crm.local` / `Admin123!`
- **Male User**: `male@crm.local` / `Male123!`
- **Female User**: `female@crm.local` / `Female123!`

## Getting Help

1. Check `/skills/` for quick guides
2. Read relevant docs in `/docs/`
3. Review `.cursorrules` for coding standards
4. Check GitHub Issues for known problems

## Contributing

See `DEVELOPMENT.md` for:
- Git workflow
- Code style guide
- Testing requirements
- PR guidelines

## License

[Add your license here]

---

**Last Updated**: 2025-12-31
**Version**: 1.0.0
