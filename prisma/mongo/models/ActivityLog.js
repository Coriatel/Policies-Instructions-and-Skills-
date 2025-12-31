const mongoose = require('mongoose');

const activityLogSchema = new mongoose.Schema(
  {
    userId: {
      type: String,
      required: false,
      index: true,
    },
    action: {
      type: String,
      required: true,
      index: true,
    },
    resource: {
      type: String,
      required: false,
    },
    metadata: {
      type: mongoose.Schema.Types.Mixed,
      required: false,
    },
    ipAddress: {
      type: String,
      required: false,
    },
    userAgent: {
      type: String,
      required: false,
    },
    timestamp: {
      type: Date,
      default: Date.now,
      index: true,
    },
  },
  {
    collection: 'activity_logs',
    timestamps: true,
  }
);

// TTL index - auto-delete logs older than 90 days
activityLogSchema.index({ timestamp: 1 }, { expireAfterSeconds: 7776000 });

module.exports = mongoose.model('ActivityLog', activityLogSchema);
