# Assumptions & Design Decisions

This document tracks all assumptions and defaults chosen during the autonomous bootstrap process.

## Date: 2025-12-31

### Tech Stack Decisions

#### Frontend (React + Vite)
- **Build tool**: Vite (faster than CRA, modern)
- **Port**: 5173 (Vite default)
- **State management**: React Context API (sufficient for CRM-lite; can upgrade to Zustand/Redux later)
- **Routing**: React Router v6
- **Forms**: React Hook Form + validation
- **HTTP client**: Axios
- **i18n library**: react-i18next
- **Default locale**: he-IL (Hebrew)
- **Supported locales**: Hebrew (he), English (en)
- **RTL**: Enabled by default, CSS follows RTL-first approach

#### Backend (Express + Node.js)
- **Node version**: 18+ LTS
- **Port**: 3001
- **Auth strategy**: JWT (with refresh tokens)
- **Password hashing**: bcrypt
- **Session storage**: In-memory for dev, Redis-ready for production
- **CORS**: Enabled for localhost:5173
- **Rate limiting**: Basic express-rate-limit
- **Logging**: Winston

#### Database
- **PostgreSQL**:
  - Version: 15
  - Port: 5432
  - Database name: `crm_db`
  - Schema managed via Prisma
  - Stores: users, roles, permissions, content, audit logs
- **MongoDB**:
  - Version: 6
  - Port: 27017
  - Database name: `crm_logs`
  - Use case: activity logs, analytics events (non-critical data)
  - Access: Mongoose (lightweight adapter, isolated from Prisma)

#### Prisma
- **Provider**: PostgreSQL as primary
- **Migration strategy**: Prisma Migrate (dev + production)
- **Seed data**: Basic admin user + sample roles
- **Naming**: camelCase for fields, snake_case for DB columns

### Domain & Business Logic

#### Roles & Permissions
- **Roles**:
  - `admin` - full access
  - `male` - male-specific content + public
  - `female` - female-specific content + public
- **Content visibility**:
  - `public` - all authenticated users
  - `male_only` - only male + admin
  - `female_only` - only female + admin
  - `admin_only` - admin only
- **Default role**: `male` (can be changed during registration)

#### Authentication
- **Login**: Email + password
- **JWT expiry**: Access token 15min, refresh token 7 days
- **Password requirements**: Min 8 chars, 1 uppercase, 1 number
- **Registration**: Self-signup enabled (can be disabled via env)

### Development Environment

#### Docker Compose
- Services: postgres, mongo, pgadmin (optional), mongo-express (optional)
- Network: bridge (default)
- Volumes: persisted for databases
- Auto-start: All services on `docker-compose up`

#### Environment Variables
- `.env.example` files provided in each app
- Secrets required: JWT_SECRET, DB passwords
- Defaults: Local development values (postgres/postgres, mongo/mongo)

### Testing

#### Unit Tests
- **Frontend**: Vitest + React Testing Library
- **Backend**: Vitest + Supertest
- **Coverage target**: 70%+

#### E2E Tests
- **Framework**: Playwright
- **Browsers**: Chromium (primary), Firefox, WebKit (optional)
- **Test data**: Seeded via Prisma
- **Tests include**: Login flow, RBAC checks, CRUD operations

### CI/CD

#### GitHub Actions
- **Triggers**: Push to main/develop, PRs
- **Jobs**: Lint, Test (unit), Build, E2E (optional on main)
- **Node version**: 18.x
- **Caching**: npm dependencies
- **Deployment**: Manual (ready for Vercel/Railway/Docker deploy)

### Code Style

#### Linting
- **ESLint**: Airbnb base config (adapted for React, no TS)
- **Prettier**: 2-space indent, single quotes, semicolons
- **Import order**: Built-in → external → internal → relative

#### File Naming
- **Components**: PascalCase (Button.jsx)
- **Utilities**: camelCase (dateUtils.js)
- **Constants**: UPPER_SNAKE_CASE (API_BASE_URL.js)
- **Styles**: kebab-case (auth-form.scss)

### Project Structure Philosophy
- **Monorepo-lite**: Simple folder structure, no Nx/Turborepo overhead
- **Shared code**: `/packages/shared` for common validation, types, constants
- **API versioning**: `/api/v1/...` routes prepared
- **Feature folders**: Considered but deferred (can refactor later)

### Security Defaults
- **Helmet.js**: Enabled for Express (security headers)
- **SQL injection**: Prevented via Prisma parameterized queries
- **XSS**: Sanitized inputs on API, CSP headers
- **CSRF**: Not needed for JWT-based API (stateless)
- **Secrets**: Never committed, .env in .gitignore

### Deployment Readiness
- **Production build**: `npm run build` in each app
- **Migrations**: `npx prisma migrate deploy` before app start
- **Health checks**: `/api/health` endpoint
- **Graceful shutdown**: SIGTERM handling in Express

### Known Limitations & Future Work
1. **No TypeScript**: As requested; can migrate incrementally later
2. **Basic RBAC**: Simple role-based; can extend to permission-based (ABAC)
3. **MongoDB minimal**: Only logs; can expand to caching, queues
4. **No Redis yet**: Can add for sessions/caching when needed
5. **No real-time**: Can add Socket.io for chat/notifications
6. **No email service**: Placeholder for password reset (add SendGrid/Mailgun later)
7. **No file uploads**: Can add Multer + S3 when needed
8. **No analytics**: Can integrate GA/Mixpanel later

### Design Choices Rationale
- **Why Vite over CRA?** Faster HMR, modern, better DX
- **Why Prisma?** Type-safe, migrations, great DX, supports both SQL and MongoDB via separate clients
- **Why SCSS over CSS-in-JS?** Better RTL support, simpler for theming, team preference
- **Why JWT over sessions?** Stateless, mobile-ready, scalable
- **Why Playwright over Cypress?** Multi-browser, faster, better API
- **Why monorepo-lite?** Simplicity; can upgrade to Nx later if needed

---

**Last Updated**: 2025-12-31
**Updated By**: Autonomous Bootstrapper (Claude)
