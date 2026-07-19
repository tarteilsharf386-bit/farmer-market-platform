const express = require('express');
const router = express.Router();
const Crop = require('../models/Crop');
const ContactRequest = require('../models/ContactRequest');
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
// طلب تواصل مع مزارع
router.post('/contact', async (req, res) => {
  try {
    const { cropId, buyerId } = req.body;
    const newRequest = new ContactRequest({ crop: cropId, buyer: buyerId });
    await newRequest.save();
    res.status(201).json({ message: 'تم إرسال طلب التواصل بنجاح' });
  } catch (error) {
    res.status(500).json({ message: 'حدث خطأ', error: error.message });
  }
});
// حساب متوسط سعر السوق لكل فئة محصول
router.get('/market-prices', async (req, res) => {
  try {
    const prices = await Crop.aggregate([
      {
        $group: {
          _id: '$category',
          avgPrice: { $avg: '$price' },
          count: { $sum: 1 }
        }
      }
    ]);
    res.status(200).json(prices);
  } catch (error) {
    res.status(500).json({ message: 'حدث خطأ', error: error.message });
  }
});
// تعديل محصول
router.put('/:id', async (req, res) => {
  try {
    const { title, category, price, quantity, unit, location } = req.body;
    const updated = await Crop.findByIdAndUpdate(
      req.params.id,
      { title, category, price, quantity, unit, location },
      { new: true }
    );
    res.status(200).json({ message: 'تم تحديث المحصول بنجاح', crop: updated });
  } catch (error) {
    res.status(500).json({ message: 'حدث خطأ', error: error.message });
  }
});

// عرض محاصيل مزارع معين
router.get('/farmer/:farmerId', async (req, res) => {
  try {
    const crops = await Crop.find({ farmer: req.params.farmerId });
    res.status(200).json(crops);
  } catch (error) {
    res.status(500).json({ message: 'حدث خطأ', error: error.message });
  }
});
module.exports = router;