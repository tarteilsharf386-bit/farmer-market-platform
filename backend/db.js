const mongoose = require('mongoose');
const dns = require('dns');
require('dotenv').config();

// إجبار Node على استخدام DNS جوجل
dns.setServers(['8.8.8.8', '8.8.4.4']);

const connectDB = async () => {
  try {
    await mongoose.connect(process.env.MONGODB_URI);
    console.log('تم الاتصال بقاعدة البيانات بنجاح ✅');
  } catch (error) {
    console.error('فشل الاتصال بقاعدة البيانات:', error.message);
    process.exit(1);
  }
};

module.exports = connectDB;