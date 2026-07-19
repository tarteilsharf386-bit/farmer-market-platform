const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const User = require('../models/User');

// مسار التسجيل (Register)
router.post('/register', async (req, res) => {
  try {
    const { name, phone, password, role, location } = req.body;

    const existingUser = await User.findOne({ phone });
    if (existingUser) {
      return res.status(400).json({ message: 'رقم الهاتف مستخدم بالفعل' });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

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

// توليد رمز تحقق مؤقت (محاكاة SMS)
router.post('/send-otp', async (req, res) => {
  try {
    const { phone } = req.body;

    const user = await User.findOne({ phone });
    if (!user) {
      return res.status(400).json({ message: 'رقم الهاتف غير مسجل' });
    }

    const otp = Math.floor(1000 + Math.random() * 9000).toString();
    user.otp = otp;
    user.otpExpires = Date.now() + 5 * 60 * 1000;
    await user.save();

    res.status(200).json({ message: 'تم إرسال رمز التحقق', otp: otp });
  } catch (error) {
    res.status(500).json({ message: 'حدث خطأ', error: error.message });
  }
});

// التحقق من الرمز وتغيير كلمة المرور
router.post('/verify-otp', async (req, res) => {
  try {
    const { phone, otp, newPassword } = req.body;

    const user = await User.findOne({ phone });
    if (!user || user.otp !== otp || Date.now() > user.otpExpires) {
      return res.status(400).json({ message: 'رمز التحقق غير صحيح أو منتهي الصلاحية' });
    }

    const hashedPassword = await bcrypt.hash(newPassword, 10);
    user.password = hashedPassword;
    user.otp = undefined;
    user.otpExpires = undefined;
    await user.save();

    res.status(200).json({ message: 'تم تغيير كلمة المرور بنجاح' });
  } catch (error) {
    res.status(500).json({ message: 'حدث خطأ', error: error.message });
  }
});

module.exports = router;