const express = require('express');
const contentController = require('../controllers/content.controller');
const { authenticate } = require('../middleware/auth');
const { filterContentByRole } = require('../middleware/rbac');
const { validate } = require('../middleware/validate');
const { createContentSchema, updateContentSchema } = require('../validation/content.validation');

const router = express.Router();

router.use(authenticate);
router.use(filterContentByRole);

router.get('/', contentController.getAllContent);
router.get('/:id', contentController.getContentById);
router.post('/', validate(createContentSchema), contentController.createContent);
router.patch('/:id', validate(updateContentSchema), contentController.updateContent);
router.delete('/:id', contentController.deleteContent);

module.exports = router;
