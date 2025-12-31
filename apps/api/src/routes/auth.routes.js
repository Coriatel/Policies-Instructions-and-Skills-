const express = require('express');
const authController = require('../controllers/auth.controller');
const { validate } = require('../middleware/validate');
const { loginSchema, registerSchema, refreshSchema } = require('../validation/auth.validation');

const router = express.Router();

router.post('/register', validate(registerSchema), authController.register);
router.post('/login', validate(loginSchema), authController.login);
router.post('/refresh', validate(refreshSchema), authController.refresh);
router.post('/logout', authController.logout);

module.exports = router;
