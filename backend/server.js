const express = require('express');
const cors = require('cors');
require('dotenv').config();
const connectDB = require('./db');
const authRoutes = require('./routes/authRoutes');
const cropRoutes = require('./routes/cropRoutes');
const app = express();

connectDB();

app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
  res.send('مرحباً! السيرفر شغال بنجاح 🚀');
});

// مسارات التسجيل وتسجيل الدخول
app.use('/api/auth', authRoutes);
app.use('/api/crops', cropRoutes);
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`السيرفر شغال على المنفذ ${PORT}`);
});