# Project Context

## מטרת הפרויקט
מערכת/כלי שמדגיש UI טבלאי ברור, ותהליכי עבודה מדויקים (כולל עברית/RTL).

---

## סטאק טכנולוגי

### Frontend
- **Framework**: React + JavaScript (NO TypeScript)
- **Styling**: SCSS with BEM naming
- **i18n**: react-i18next (Hebrew default)
- **RTL**: CSS Logical Properties

### Backend
- **Runtime**: Node.js
- **Framework**: Express
- **Validation**: Joi
- **Auth**: JWT (access + refresh tokens)

### Database
- **Primary**: PostgreSQL with Prisma ORM
- **Secondary**: MongoDB (for logs only, if needed)

### Testing
- **Unit**: Vitest
- **E2E**: Playwright

### Deployment
- **Container**: Docker + Docker Compose
- **Reverse Proxy**: Caddy (or Nginx)
- **Hosting**: Hostinger VPS

---

## UX/UI עקרונות

### RTL by Default
- כל הUI בעברית כברירת מחדל
- CSS Logical Properties: `margin-inline-start` לא `margin-left`
- מספרים וURLs ב-LTR בתוך container עם RTL

### טבלאות
- מיון/סינון/חיפוש מובנה
- סטטוסים בצבע/תגיות
- פעולות שורה (Actions) בצד שמאל
- Pagination
- Empty state ברור

### Layout עקרונות
- Responsive: Mobile-first
- Sidebar לניווט (בצד ימין ב-RTL)
- Header עם פעולות גלובליות
- Content area ברור

---

## File Structure

```
project/
├── apps/
│   ├── web/                 # Frontend React app
│   │   ├── src/
│   │   │   ├── components/  # Reusable components
│   │   │   ├── pages/       # Page components
│   │   │   ├── hooks/       # Custom hooks
│   │   │   ├── utils/       # Utilities
│   │   │   ├── locales/     # i18n files (he.json, en.json)
│   │   │   └── styles/      # Global SCSS
│   │   └── package.json
│   │
│   └── api/                 # Backend Express app
│       ├── src/
│       │   ├── routes/      # API routes
│       │   ├── controllers/ # Route handlers
│       │   ├── middleware/  # Express middleware
│       │   ├── validation/  # Joi schemas
│       │   └── utils/       # Utilities
│       └── package.json
│
├── prisma/
│   └── postgres/
│       ├── schema.prisma
│       └── seed.js
│
├── e2e/                     # Playwright tests
├── scripts/                 # Helper scripts
├── docker-compose.yml
└── package.json             # Root package.json
```

---

## Naming Conventions

### Files
- Components: `PascalCase.jsx` (e.g., `UserTable.jsx`)
- Utils: `camelCase.js` (e.g., `dateUtils.js`)
- Styles: `kebab-case.scss` (e.g., `user-table.scss`)
- Tests: `*.test.js` or `*.spec.js`

### Code
- Components: PascalCase
- Functions: camelCase
- Constants: UPPER_SNAKE_CASE
- CSS Classes: BEM (`.block__element--modifier`)

---

## API Conventions

### Routes
```
GET    /api/v1/resources       # List
GET    /api/v1/resources/:id   # Get one
POST   /api/v1/resources       # Create
PUT    /api/v1/resources/:id   # Update
DELETE /api/v1/resources/:id   # Delete
```

### Response Format
```json
{
  "success": true,
  "data": { ... },
  "meta": {
    "page": 1,
    "total": 100
  }
}
```

### Error Format
```json
{
  "success": false,
  "error": "Error message",
  "details": [ ... ]  // Optional validation errors
}
```

---

## Environment Variables

Required in `.env`:
```bash
# Database
DATABASE_URL=postgresql://user:pass@localhost:5432/dbname

# Auth
JWT_SECRET=your-secret-key
JWT_ACCESS_EXPIRY=15m
JWT_REFRESH_EXPIRY=7d

# Server
PORT=3000
NODE_ENV=development

# Optional
MONGODB_URL=mongodb://localhost:27017/logs
```

---

## Quick Commands

```bash
# Development
npm run dev           # Start all services
npm run dev:web       # Frontend only
npm run dev:api       # Backend only

# Database
npm run db:migrate    # Run migrations
npm run db:seed       # Seed database
npm run db:studio     # Open Prisma Studio

# Testing
npm test              # All tests
npm run test:unit     # Unit tests only
npm run test:e2e      # E2E tests only

# Build
npm run build         # Build all
npm run lint          # Lint all
```

---

**Last Updated**: 2026-01
