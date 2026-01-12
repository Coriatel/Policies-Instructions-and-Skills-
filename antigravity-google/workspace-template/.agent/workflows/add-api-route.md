# /add-api-route

**Workspace Workflow** - הוספת API route חדש

## מתי להשתמש
- הוספת endpoint חדש
- הוספת CRUD לresource חדש

## Input נדרש
- **Resource name**: שם ה-resource (e.g., "products")
- **Operations**: אילו operations (GET list, GET one, POST, PUT, DELETE)
- **Auth required**: האם צריך authentication
- **Roles**: אילו roles יכולים לגשת

---

## הצעדים

### 1. יצירת Route File
`/apps/api/src/routes/{resource}.routes.js`

```javascript
const express = require('express');
const router = express.Router();
const controller = require('../controllers/{resource}.controller');
const { validate } = require('../middleware/validate');
const { requireAuth, requireRole } = require('../middleware/auth');
const schemas = require('../validation/{resource}.validation');

// GET /api/v1/{resource}
router.get('/',
  requireAuth,
  controller.list
);

// GET /api/v1/{resource}/:id
router.get('/:id',
  requireAuth,
  controller.getOne
);

// POST /api/v1/{resource}
router.post('/',
  requireAuth,
  requireRole(['ADMIN']),
  validate(schemas.create),
  controller.create
);

// PUT /api/v1/{resource}/:id
router.put('/:id',
  requireAuth,
  requireRole(['ADMIN']),
  validate(schemas.update),
  controller.update
);

// DELETE /api/v1/{resource}/:id
router.delete('/:id',
  requireAuth,
  requireRole(['ADMIN']),
  controller.remove
);

module.exports = router;
```

### 2. יצירת Controller
`/apps/api/src/controllers/{resource}.controller.js`

```javascript
const prisma = require('../lib/prisma');

exports.list = async (req, res, next) => {
  try {
    const { page = 1, limit = 20, search } = req.query;
    const skip = (page - 1) * limit;

    const where = search
      ? { name: { contains: search, mode: 'insensitive' } }
      : {};

    const [items, total] = await Promise.all([
      prisma.{resource}.findMany({
        where,
        skip,
        take: parseInt(limit),
        orderBy: { createdAt: 'desc' },
      }),
      prisma.{resource}.count({ where }),
    ]);

    res.json({
      success: true,
      data: items,
      meta: { page: parseInt(page), limit: parseInt(limit), total },
    });
  } catch (error) {
    next(error);
  }
};

exports.getOne = async (req, res, next) => {
  try {
    const { id } = req.params;

    const item = await prisma.{resource}.findUnique({
      where: { id },
    });

    if (!item) {
      return res.status(404).json({
        success: false,
        error: 'Not found',
      });
    }

    res.json({ success: true, data: item });
  } catch (error) {
    next(error);
  }
};

exports.create = async (req, res, next) => {
  try {
    const item = await prisma.{resource}.create({
      data: req.body,
    });

    res.status(201).json({ success: true, data: item });
  } catch (error) {
    next(error);
  }
};

exports.update = async (req, res, next) => {
  try {
    const { id } = req.params;

    const item = await prisma.{resource}.update({
      where: { id },
      data: req.body,
    });

    res.json({ success: true, data: item });
  } catch (error) {
    if (error.code === 'P2025') {
      return res.status(404).json({
        success: false,
        error: 'Not found',
      });
    }
    next(error);
  }
};

exports.remove = async (req, res, next) => {
  try {
    const { id } = req.params;

    await prisma.{resource}.delete({ where: { id } });

    res.json({ success: true, message: 'Deleted' });
  } catch (error) {
    if (error.code === 'P2025') {
      return res.status(404).json({
        success: false,
        error: 'Not found',
      });
    }
    next(error);
  }
};
```

### 3. יצירת Validation Schema
`/apps/api/src/validation/{resource}.validation.js`

```javascript
const Joi = require('joi');

exports.create = Joi.object({
  name: Joi.string().required().max(255),
  description: Joi.string().allow('').max(1000),
  // Add more fields
});

exports.update = Joi.object({
  name: Joi.string().max(255),
  description: Joi.string().allow('').max(1000),
  // Add more fields
}).min(1); // At least one field required
```

### 4. רישום ב-Routes Index
`/apps/api/src/routes/index.js`

```javascript
const {resource}Routes = require('./{resource}.routes');

// Add to router
router.use('/{resource}', {resource}Routes);
```

### 5. עדכון Prisma Schema (אם צריך)
`/prisma/postgres/schema.prisma`

```prisma
model {Resource} {
  id          String   @id @default(uuid())
  name        String
  description String?
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt
}
```

### 6. הרצת Migration
```bash
npm run db:migrate --workspace=apps/api
```

### 7. בדיקה
```bash
# Test endpoints
curl http://localhost:3000/api/v1/{resource}
curl http://localhost:3000/api/v1/{resource}/123
curl -X POST http://localhost:3000/api/v1/{resource} -H "Content-Type: application/json" -d '{"name":"test"}'
```

---

## Checklist

- [ ] Route file created
- [ ] Controller created
- [ ] Validation schema created
- [ ] Route registered in index
- [ ] Prisma schema updated (if new model)
- [ ] Migration run
- [ ] Tested manually
- [ ] Unit tests added

---

**Output**: Working API endpoint with full CRUD
