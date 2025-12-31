# CRM Platform

A modern, role-based CRM platform with content management capabilities. Built with React, Node.js, and PostgreSQL.

![Status](https://img.shields.io/badge/status-active-success.svg)
![License](https://img.shields.io/badge/license-MIT-blue.svg)

## 🚀 Features

- **Role-Based Access Control (RBAC)**: Admin, Male, Female roles with granular permissions
- **Content Management**: Create, edit, delete content with visibility controls
- **RTL Support**: Hebrew-first design with full RTL layout
- **Internationalization**: Hebrew and English languages
- **JWT Authentication**: Secure token-based auth with refresh tokens
- **Modern Stack**: React + Vite, Express, Prisma, PostgreSQL, MongoDB
- **Comprehensive Testing**: Unit, integration, and E2E tests
- **Docker Support**: Full local development environment

## 📋 Prerequisites

- Node.js 18+ and npm 9+
- Docker and Docker Compose
- Git

## 🏃 Quick Start

### 1. Install Dependencies

```bash
npm install
```

### 2. Start Databases

```bash
npm run docker:up
```

### 3. Configure Environment

```bash
cp apps/api/.env.example apps/api/.env
```

### 4. Run Migrations & Seed

```bash
npm run db:migrate --workspace=apps/api
npm run db:seed --workspace=apps/api
```

### 5. Start Development Servers

```bash
npm run dev
```

Visit: **http://localhost:5173**

### 6. Login with Test Accounts

- **Admin**: `admin@crm.local` / `Admin123!`
- **Male User**: `male@crm.local` / `Male123!`
- **Female User**: `female@crm.local` / `Female123!`

## 📚 Documentation

- **[Getting Started](/skills/getting-started.md)** - Complete setup guide
- **[Architecture](/docs/ARCHITECTURE.md)** - System design and architecture
- **[Development Guide](/docs/DEVELOPMENT.md)** - Development workflow
- **[API Reference](/docs/API.md)** - API endpoints and examples
- **[Skills](/skills/)** - Quick reference guides for common tasks
- **[Cursor Rules](/.cursorrules)** - Coding standards and best practices

## 🛠️ Tech Stack

### Frontend
- React 18
- Vite
- SCSS (RTL-first)
- React Router v6
- i18next
- Axios

### Backend
- Node.js 18+
- Express
- Prisma (PostgreSQL ORM)
- Mongoose (MongoDB)
- JWT + Bcrypt
- Winston (logging)

### Databases
- PostgreSQL 15 (primary)
- MongoDB 6 (activity logs)

### Testing
- Vitest (unit tests)
- React Testing Library
- Playwright (E2E)

### DevOps
- Docker Compose
- GitHub Actions CI/CD
- ESLint + Prettier

## 📂 Project Structure

```
crm-platform/
├── apps/
│   ├── api/              # Express API
│   └── web/              # React frontend
├── packages/
│   └── shared/           # Shared utilities
├── prisma/
│   ├── postgres/         # PostgreSQL schema
│   └── mongo/            # MongoDB models
├── e2e/                  # Playwright tests
├── skills/               # Quick guides
├── docs/                 # Documentation
└── docker-compose.yml    # Local dev environment
```

## 🧪 Testing

```bash
# Run all tests
npm test

# E2E tests
npm run test:e2e

# E2E with UI
npm run test:e2e:ui --workspace=e2e
```

## 🔧 Common Commands

```bash
# Development
npm run dev              # Start both API and Web
npm run dev:api          # Start API only
npm run dev:web          # Start Web only

# Database
npm run db:migrate --workspace=apps/api    # Run migrations
npm run db:seed --workspace=apps/api       # Seed database
npm run db:studio --workspace=apps/api     # Open Prisma Studio

# Docker
npm run docker:up        # Start databases
npm run docker:down      # Stop databases

# Code Quality
npm run lint             # Run ESLint
npm run format           # Format with Prettier

# Build
npm run build            # Build all apps
```

## 🔐 RBAC (Role-Based Access Control)

### Roles
- **ADMIN**: Full access to all features and content
- **MALE**: Access to male-specific + public content
- **FEMALE**: Access to female-specific + public content

### Content Visibility
- **PUBLIC**: All authenticated users
- **MALE_ONLY**: Male users + Admins
- **FEMALE_ONLY**: Female users + Admins
- **ADMIN_ONLY**: Admins only

## 🌍 Internationalization

Default language: **Hebrew (עברית)**

Supported languages:
- Hebrew (he)
- English (en)

All UI text is managed through i18next with full RTL support.

## 🚢 Deployment

See **[Deployment Guide](/skills/deployment.md)** for detailed instructions.

Quick options:
- **Docker**: `docker-compose -f docker-compose.prod.yml up -d`
- **Vercel** (Web) + **Railway** (API)
- **Render** / **Heroku**

## 🔒 Security

- JWT-based authentication
- Bcrypt password hashing (10 rounds)
- Helmet.js security headers
- CORS protection
- Rate limiting (100 req/15min)
- SQL injection prevention (Prisma)
- XSS prevention (React escaping)

## 📈 Future Enhancements

- [ ] Redis for caching and sessions
- [ ] File upload support (images, documents)
- [ ] Email notifications (password reset, alerts)
- [ ] Real-time updates (Socket.io)
- [ ] Advanced analytics dashboard
- [ ] Two-factor authentication (2FA)
- [ ] Mobile app (React Native)
- [ ] API rate limiting per user
- [ ] Audit trail UI

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'feat: add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

See **[Development Guide](/docs/DEVELOPMENT.md)** for more details.

## 📝 License

[MIT License](LICENSE)

## 🙏 Acknowledgments

- Built with modern best practices
- Follows Airbnb style guide
- Inspired by real-world CRM systems
- Designed for Hebrew-speaking communities

## 📞 Support

- **Documentation**: `/docs/` and `/skills/`
- **Issues**: GitHub Issues
- **Questions**: See `/docs/README.md`

---

**Built with ❤️ using React, Node.js, and PostgreSQL**

**Last Updated**: 2025-12-31 | **Version**: 1.0.0
