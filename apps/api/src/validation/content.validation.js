const Joi = require('joi');

const createContentSchema = Joi.object({
  title: Joi.string().min(3).max(200).required(),
  description: Joi.string().max(500).optional().allow(''),
  body: Joi.string().required(),
  visibility: Joi.string().valid('PUBLIC', 'MALE_ONLY', 'FEMALE_ONLY', 'ADMIN_ONLY').optional(),
  isPublished: Joi.boolean().optional(),
});

const updateContentSchema = Joi.object({
  title: Joi.string().min(3).max(200).optional(),
  description: Joi.string().max(500).optional().allow(''),
  body: Joi.string().optional(),
  visibility: Joi.string().valid('PUBLIC', 'MALE_ONLY', 'FEMALE_ONLY', 'ADMIN_ONLY').optional(),
  isPublished: Joi.boolean().optional(),
});

module.exports = {
  createContentSchema,
  updateContentSchema,
};
