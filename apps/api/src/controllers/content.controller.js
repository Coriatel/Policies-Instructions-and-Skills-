const { prisma } = require('../config/prisma');
const { checkContentAccess } = require('../middleware/rbac');

const getAllContent = async (req, res, next) => {
  try {
    const { visibility, isPublished } = req.query;

    const where = {
      ...req.visibilityWhere,
      ...(visibility && { visibility }),
      ...(typeof isPublished !== 'undefined' && { isPublished: isPublished === 'true' }),
    };

    const content = await prisma.content.findMany({
      where,
      include: {
        author: {
          select: {
            id: true,
            firstName: true,
            lastName: true,
          },
        },
      },
      orderBy: { createdAt: 'desc' },
    });

    res.json({ content });
  } catch (error) {
    next(error);
  }
};

const getContentById = async (req, res, next) => {
  try {
    const { id } = req.params;

    const content = await prisma.content.findUnique({
      where: { id },
      include: {
        author: {
          select: {
            id: true,
            firstName: true,
            lastName: true,
          },
        },
      },
    });

    if (!content) {
      return res.status(404).json({ error: 'Content not found' });
    }

    if (!checkContentAccess(content, req.user.role)) {
      return res.status(403).json({ error: 'Access denied to this content' });
    }

    res.json({ content });
  } catch (error) {
    next(error);
  }
};

const createContent = async (req, res, next) => {
  try {
    const { title, description, body, visibility, isPublished } = req.validatedBody;

    const content = await prisma.content.create({
      data: {
        title,
        description,
        body,
        visibility: visibility || 'PUBLIC',
        isPublished: isPublished || false,
        authorId: req.user.id,
      },
      include: {
        author: {
          select: {
            id: true,
            firstName: true,
            lastName: true,
          },
        },
      },
    });

    res.status(201).json({ content });
  } catch (error) {
    next(error);
  }
};

const updateContent = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { title, description, body, visibility, isPublished } = req.validatedBody;

    const existingContent = await prisma.content.findUnique({
      where: { id },
    });

    if (!existingContent) {
      return res.status(404).json({ error: 'Content not found' });
    }

    if (existingContent.authorId !== req.user.id && req.user.role !== 'ADMIN') {
      return res.status(403).json({ error: 'You can only edit your own content' });
    }

    const content = await prisma.content.update({
      where: { id },
      data: {
        ...(title && { title }),
        ...(description !== undefined && { description }),
        ...(body && { body }),
        ...(visibility && { visibility }),
        ...(typeof isPublished === 'boolean' && { isPublished }),
      },
      include: {
        author: {
          select: {
            id: true,
            firstName: true,
            lastName: true,
          },
        },
      },
    });

    res.json({ content });
  } catch (error) {
    next(error);
  }
};

const deleteContent = async (req, res, next) => {
  try {
    const { id } = req.params;

    const content = await prisma.content.findUnique({
      where: { id },
    });

    if (!content) {
      return res.status(404).json({ error: 'Content not found' });
    }

    if (content.authorId !== req.user.id && req.user.role !== 'ADMIN') {
      return res.status(403).json({ error: 'You can only delete your own content' });
    }

    await prisma.content.delete({ where: { id } });

    res.json({ message: 'Content deleted successfully' });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  getAllContent,
  getContentById,
  createContent,
  updateContent,
  deleteContent,
};
