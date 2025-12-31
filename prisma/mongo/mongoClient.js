const mongoose = require('mongoose');

let isConnected = false;

const connectMongo = async () => {
  if (isConnected) {
    return;
  }

  try {
    const mongoUrl = process.env.MONGO_URL || 'mongodb://mongo:mongo@localhost:27017/crm_logs';

    await mongoose.connect(mongoUrl, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });

    isConnected = true;
    console.log('✅ MongoDB connected');
  } catch (error) {
    console.error('❌ MongoDB connection failed:', error);
    throw error;
  }
};

const disconnectMongo = async () => {
  if (!isConnected) {
    return;
  }

  await mongoose.disconnect();
  isConnected = false;
  console.log('MongoDB disconnected');
};

module.exports = { connectMongo, disconnectMongo };
