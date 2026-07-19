const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const User = require('../models/User');

// مسار التسجيل (Register)
router.post('/register', async (req, res) => {
  try {
    const { name, phone, password, role, location } = req.body;

    // تأكدي إن رقم الهاتف مو مستخدم من قبل
    const existingUser = await User.findOne({ phone });
    if (existingUser) {
      return res.status(400).json({ message: 'رقم الهاتف مستخدم بالفعل' });
    }

    // تشفير كلمة المرور
    const hashedPassword = await bcrypt.hash(password, 10);

    // إنشاء المستخدم الجديد
    const newUser = new User({
      name,
      phone,
      password: hashedPassword,
      role,
      location
    });

    await newUser.save();

    res.status(201).json({ message: 'تم إنشاء الحساب بنجاح', userId: newUser._id });
  } catch (error) {
    res.status(500).json({ message: 'حدث خطأ', error: error.message });
  }
});

// مسار تسجيل الدخول (Login)
router.post('/login', async (req, res) => {
  try {
    const { phone, password } = req.body;

    const user = await User.findOne({ phone });
    if (!user) {
      return res.status(400).json({ message: 'رقم الهاتف أو كلمة المرور غير صحيحة' });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ message: 'رقم الهاتف أو كلمة المرور غير صحيحة' });
    }

    const token = jwt.sign(
      { userId: user._id, role: user.role },
      process.env.JWT_SECRET || 'secretkey123',
      { expiresIn: '7d' }
    );

    res.status(200).json({
      message: 'تم تسجيل الدخول بنجاح',
      token,
      user: { id: user._id, name: user.name, role: user.role }
    });
  } catch (error) {
    res.status(500).json({ message: 'حدث خطأ', error: error.message });
  }
});
// جلب بيانات مستخدم واحد
router.get('/user/:id', async (req, res) => {
  try {
    const user = await User.findById(req.params.id).select('-password');
    res.status(200).json(user);
  } catch (error) {
    res.status(500).json({ message: 'حدث خطأ', error: error.message });
  }
});

// تحديث بيانات المستخدم
router.put('/user/:id', async (req, res) => {
  try {
    const { name, location } = req.body;
    const updatedUser = await User.findByIdAndUpdate(
      req.params.id,
      { name, location },
      { new: true }
    ).select('-password');
    res.status(200).json({ message: 'تم تحديث البيانات بنجاح', user: updatedUser });
  } catch (error) {
    res.status(500).json({ message: 'حدث خطأ', error: error.message });
  }
});
module.exports = router;