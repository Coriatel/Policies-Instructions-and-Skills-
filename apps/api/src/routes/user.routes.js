const express = require('express');
const userController = require('../controllers/user.controller');
const { authenticate } = require('../middleware/auth');
const { requireAdmin } = require('../middleware/rbac');

const router = express.Router();

router.get('/me', authenticate, userController.getCurrentUser);
router.get('/', authenticate, requireAdmin, userController.getAllUsers);
router.get('/:id', authenticate, requireAdmin, userController.getUserById);
router.patch('/:id', authenticate, requireAdmin, userController.updateUser);
router.delete('/:id', authenticate, requireAdmin, userController.deleteUser);

module.exports = router;
