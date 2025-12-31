# Architecture

This document describes the system architecture and design decisions for the CRM platform.

## High-Level Architecture

```
┌─────────────────┐
│   React Web     │ Port 5173
│   (Vite + SCSS) │
└────────┬────────┘
         │ HTTP/REST
         │ JWT Auth
┌────────▼────────┐
│  Express API    │ Port 3001
│  (Node.js)      │
└────┬──────┬─────┘
     │      │
     │      └──────────┐
┌────▼─────┐    ┌──────▼─────┐
│PostgreSQL│    │  MongoDB   │
│  (Prisma)│    │ (Mongoose) │
│ Port 5432│    │ Port 27017 │
└──────────┘    └────────────┘
```

## Frontend Architecture

### Technology Stack
- **React 18**: UI library (functional components + hooks)
- **Vite**: Build tool and dev server
- **React Router v6**: Client-side routing
- **SCSS**: Styling with RTL support
- **i18next**: Internationalization (Hebrew/English)
- **Axios**: HTTP client with interceptors

### State Management
- **React Context API**: Global state (AuthContext)
- **Local State**: Component-level with useState
- **Form State**: React Hook Form (future enhancement)

### Directory Structure
```
apps/web/src/
├── pages/          # Route-level components
├── components/     # Reusable UI components
├── context/        # Global state (Auth)
├── guards/         # Route protection (RBAC)
├── utils/          # Helpers (API client, i18n)
├── styles/         # Global SCSS
└── locales/        # Translations (he.json, en.json)
```

### RTL Implementation
- HTML `dir="rtl"` set by default
- SCSS follows RTL-first approach
- Flexbox/Grid layouts work bidirectionally
- i18n provides language switching

### Authentication Flow
1. User submits login form
2. API returns JWT access + refresh tokens
3. Tokens stored in localStorage
4. Axios interceptor adds token to requests
5. On 401, refresh token used to get new access token
6. On refresh failure, redirect to login

## Backend Architecture

### Technology Stack
- **Node.js 18+**: Runtime
- **Express**: Web framework
- **Prisma**: PostgreSQL ORM
- **Mongoose**: MongoDB adapter
- **JWT**: Token-based auth
- **Bcrypt**: Password hashing
- **Winston**: Logging
- **Helmet**: Security headers

### Layered Architecture

```
Routes → Middleware → Controllers → Services → Database
```

1. **Routes**: Define endpoints and apply middleware
2. **Middleware**: Validate, authenticate, authorize
3. **Controllers**: Handle request/response
4. **Services**: Business logic (future layer)
5. **Database**: Prisma (PostgreSQL), Mongoose (MongoDB)

### Directory Structure
```
apps/api/src/
├── routes/         # API routes
├── controllers/    # Request handlers
├── middleware/     # Auth, RBAC, validation
├── validation/     # Joi schemas
├── config/         # DB, logger config
└── server.js       # App entry point
```

### Middleware Stack
1. **Helmet**: Security headers
2. **CORS**: Cross-origin requests
3. **Rate Limiter**: DDoS protection
4. **Body Parser**: JSON/URL-encoded
5. **Morgan**: HTTP logging
6. **Custom Middleware**:
   - `authenticate`: Verify JWT
   - `requireRole`: Check user role
   - `filterContentByRole`: RBAC for content
   - `validate`: Joi validation
   - `errorHandler`: Centralized errors

## Database Architecture

### PostgreSQL (Primary Database)

**Purpose**: Structured data with relationships

**Schema Overview**:
```
User (id, email, password, role, ...)
  ↓ 1:N
Content (id, title, body, visibility, authorId, ...)
  ↓ 1:N
RefreshToken (id, token, userId, expiresAt)

AuditLog (id, userId, action, entity, ...)
```

**Enums**:
- `Role`: ADMIN, MALE, FEMALE
- `ContentVisibility`: PUBLIC, MALE_ONLY, FEMALE_ONLY, ADMIN_ONLY

**Indexes**:
- User: email (unique)
- Content: visibility, authorId
- AuditLog: userId, entity + entityId, createdAt

### MongoDB (Activity Logs)

**Purpose**: Non-critical, time-series data

**Collections**:
- `activity_logs`: User activity tracking

**Features**:
- TTL index (auto-delete after 90 days)
- No relations to PostgreSQL
- Used for analytics, debugging

### Why Two Databases?

- **PostgreSQL**: ACID compliance for critical data (users, content)
- **MongoDB**: Flexible schema for logs, fast writes
- **Prisma + Mongoose**: Best tool for each job
- **Isolation**: Log failures don't affect main app

## RBAC (Role-Based Access Control)

### Roles Hierarchy
```
ADMIN (full access)
  ├── MALE (male + public content)
  └── FEMALE (female + public content)
```

### Content Visibility Matrix

| Visibility    | PUBLIC | MALE_ONLY | FEMALE_ONLY | ADMIN_ONLY |
|---------------|--------|-----------|-------------|------------|
| ADMIN         | ✅      | ✅         | ✅           | ✅          |
| MALE          | ✅      | ✅         | ❌           | ❌          |
| FEMALE        | ✅      | ❌         | ✅           | ❌          |

### Implementation

**API Level**:
```javascript
// Middleware
router.get('/admin', requireRole('ADMIN'), controller);

// Content filtering
router.use(filterContentByRole);
const content = await prisma.content.findMany({
  where: req.visibilityWhere
});
```

**Frontend Level**:
```javascript
// Route protection
<ProtectedRoute requiredRole="ADMIN">
  <AdminPanel />
</ProtectedRoute>

// Conditional rendering
{user.role === 'ADMIN' && <AdminLink />}
```

## Authentication & Security

### JWT Flow
1. Login → Generate access (15min) + refresh (7d) tokens
2. Store refresh token in DB
3. Client stores both in localStorage
4. Access token sent in Authorization header
5. On expiry, use refresh token to get new access token

### Password Security
- **Bcrypt** with 10 rounds
- **Validation**: Min 8 chars, 1 uppercase, 1 number
- Never returned in API responses

### Security Headers (Helmet)
- Content Security Policy (CSP)
- X-Frame-Options: DENY
- X-Content-Type-Options: nosniff
- Strict-Transport-Security (HSTS)

### Input Validation
- **Joi schemas** for all request bodies
- **Parameterized queries** via Prisma (SQL injection prevention)
- **React** escapes output (XSS prevention)

## API Design

### RESTful Conventions
- **GET**: Retrieve resources
- **POST**: Create resources
- **PATCH**: Update resources
- **DELETE**: Remove resources

### URL Structure
```
/api/v1/{resource}
/api/v1/{resource}/{id}
/api/v1/{resource}/{id}/{sub-resource}
```

### Response Format
**Success**:
```json
{
  "user": { ... },
  "users": [ ... ],
  "content": [ ... ]
}
```

**Error**:
```json
{
  "error": "Error message",
  "details": [
    { "field": "email", "message": "Invalid email" }
  ]
}
```

### Status Codes
- **200**: OK
- **201**: Created
- **400**: Bad Request (validation)
- **401**: Unauthorized (auth failed)
- **403**: Forbidden (no permissions)
- **404**: Not Found
- **500**: Server Error

## Internationalization (i18n)

### Implementation
- **react-i18next**: React integration
- **Default language**: Hebrew (he)
- **Fallback**: Hebrew
- **Supported**: Hebrew, English

### Structure
```json
{
  "app": { "title": "...", ... },
  "auth": { "login": "...", ... },
  "errors": { "required": "...", ... }
}
```

### Usage
```javascript
const { t } = useTranslation();
<h1>{t('app.title')}</h1>
```

## Testing Strategy

### Unit Tests (Vitest)
- **API**: Controllers, middleware, utilities
- **Web**: Components, hooks, utilities
- **Coverage**: 70%+ on critical paths

### Integration Tests
- **API**: Route → Controller → Database
- **Web**: Page components with context

### E2E Tests (Playwright)
- **User flows**: Login, content CRUD, RBAC
- **Browsers**: Chromium (primary), Firefox
- **Run on**: Main branch CI

## Deployment Architecture

### Local Development
```
Docker Compose
  ├── PostgreSQL (5432)
  ├── MongoDB (27017)
  ├── pgAdmin (5050) [optional]
  └── Mongo Express (8081) [optional]

Native Processes
  ├── API (3001)
  └── Web (5173)
```

### Production (Docker)
```
Docker Compose
  ├── API (3001)
  ├── Web (80)
  ├── PostgreSQL
  └── MongoDB
```

### Production (PaaS)
- **Web**: Vercel/Netlify
- **API**: Railway/Render
- **DB**: Supabase/Railway

## Performance Considerations

### Database
- Indexes on frequently queried fields
- Pagination for large lists (future)
- Connection pooling (Prisma default)

### Frontend
- Code splitting (React.lazy) when app grows
- Memoization (React.memo, useMemo) for expensive components
- Lazy loading images

### API
- Rate limiting (100 req/15min)
- Compression (future: gzip)
- Caching (future: Redis)

## Scalability

### Current Limitations
- In-memory session store (use Redis for production)
- No horizontal scaling (stateless, can add)
- Single database (can add read replicas)

### Future Enhancements
- Redis for sessions + caching
- CDN for static assets
- Load balancer for multiple API instances
- Database read replicas
- Message queue for async tasks

## Monitoring & Observability

### Logging
- **Winston**: Structured JSON logs
- **Levels**: error, warn, info, debug
- **Outputs**: Console (dev), file (production)

### Metrics (Future)
- Request duration
- Error rates
- Database query performance
- User analytics

### Error Tracking (Future)
- Sentry for exception tracking
- Uptime monitoring
- Performance monitoring

---

**Last Updated**: 2025-12-31
