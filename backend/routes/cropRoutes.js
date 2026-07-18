const express = require('express');
const router = express.Router();
const Crop = require('../models/Crop');

// إضافة محصول جديد
router.post('/', async (req, res) => {
  try {
    const { farmer, title, category, price, quantity, unit, location } = req.body;

    const newCrop = new Crop({ farmer, title, category, price, quantity, unit, location });
    await newCrop.save();

    res.status(201).json({ message: 'تم نشر المحصول بنجاح', crop: newCrop });
  } catch (error) {
    res.status(500).json({ message: 'حدث خطأ', error: error.message });
  }
});

// عرض كل المحاصيل (مع بيانات المزارع)
router.get('/', async (req, res) => {
  try {
    const crops = await Crop.find().populate('farmer', 'name phone location');
    res.status(200).json(crops);
  } catch (error) {
    res.status(500).json({ message: 'حدث خطأ', error: error.message });
  }
});
// حذف محصول
router.delete('/:id', async (req, res) => {
  try {
    await Crop.findByIdAndDelete(req.params.id);
    res.status(200).json({ message: 'تم الحذف بنجاح' });
  } catch (error) {
    res.status(500).json({ message: 'حدث خطأ', error: error.message });
  }
});
module.exports = router;