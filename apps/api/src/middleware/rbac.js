/**
 * Role-Based Access Control Middleware
 */

const requireRole = (...allowedRoles) => {
  return (req, res, next) => {
    if (!req.user) {
      return res.status(401).json({ error: 'Authentication required' });
    }

    const userRole = req.user.role;

    if (!allowedRoles.includes(userRole)) {
      return res.status(403).json({
        error: 'Insufficient permissions',
        required: allowedRoles,
        current: userRole,
      });
    }

    next();
  };
};

const requireAdmin = requireRole('ADMIN');

/**
 * Check content visibility based on user role
 */
const checkContentAccess = (content, userRole) => {
  if (!content) return false;

  const { visibility } = content;

  switch (visibility) {
    case 'PUBLIC':
      return true;
    case 'ADMIN_ONLY':
      return userRole === 'ADMIN';
    case 'MALE_ONLY':
      return userRole === 'MALE' || userRole === 'ADMIN';
    case 'FEMALE_ONLY':
      return userRole === 'FEMALE' || userRole === 'ADMIN';
    default:
      return false;
  }
};

/**
 * Middleware to filter content based on visibility
 */
const filterContentByRole = (req, res, next) => {
  const userRole = req.user?.role;

  req.contentFilter = (content) => checkContentAccess(content, userRole);
  req.visibilityWhere = getVisibilityFilter(userRole);

  next();
};

/**
 * Get Prisma where clause for content visibility
 */
const getVisibilityFilter = (userRole) => {
  if (userRole === 'ADMIN') {
    return {}; // Admins see everything
  }

  if (userRole === 'MALE') {
    return {
      visibility: {
        in: ['PUBLIC', 'MALE_ONLY'],
      },
    };
  }

  if (userRole === 'FEMALE') {
    return {
      visibility: {
        in: ['PUBLIC', 'FEMALE_ONLY'],
      },
    };
  }

  return { visibility: 'PUBLIC' };
};

module.exports = {
  requireRole,
  requireAdmin,
  checkContentAccess,
  filterContentByRole,
  getVisibilityFilter,
};
