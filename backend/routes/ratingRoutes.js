const express = require('express');
const router = express.Router();
const Rating = require('../models/Rating');

// إضافة تقييم
router.post('/', async (req, res) => {
  try {
    const { buyerId, farmerId, score, comment } = req.body;
    const newRating = new Rating({ buyer: buyerId, farmer: farmerId, score, comment });
    await newRating.save();
    res.status(201).json({ message: 'تم إضافة التقييم بنجاح' });
  } catch (error) {
    res.status(500).json({ message: 'حدث خطأ', error: error.message });
  }
});

// جلب متوسط تقييم مزارع معين
router.get('/farmer/:farmerId', async (req, res) => {
  try {
    const ratings = await Rating.find({ farmer: req.params.farmerId }).populate('buyer', 'name');
    const avg = ratings.length > 0
      ? ratings.reduce((sum, r) => sum + r.score, 0) / ratings.length
      : 0;
    res.status(200).json({ average: avg, count: ratings.length, ratings });
  } catch (error) {
    res.status(500).json({ message: 'حدث خطأ', error: error.message });
  }
});

module.exports = router;