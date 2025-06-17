const express = require('express');
const router = express.Router();
const otpService = require('../services/otpService');

const validateMobile = (req, res, next) => {
  const { mobile } = req.body;
  if (!mobile || !/^\d{10}$/.test(mobile)) {
    return res.status(400).json({ error: 'Invalid mobile number' });
  }
  next();
};

router.post('/send', validateMobile, async (req, res) => {
  try {
    const { mobile } = req.body;
    const result = await otpService.sendOTP(mobile);
    res.status(200).json(result);
  } catch (error) {
    console.error('Error sending OTP:', error);
    res.status(500).json({ error: error.message });
  }
});

router.post('/verify', validateMobile, async (req, res) => {
  try {
    const { mobile, otp } = req.body;
    if (!otp) {
      return res.status(400).json({ error: 'OTP is required' });
    }
    const result = await otpService.verifyOTP(mobile, otp);
    res.status(200).json(result);
  } catch (error) {
    console.error('Error verifying OTP:', error);
    res.status(500).json({ error: error.message });
  }
});

router.post('/resend', validateMobile, async (req, res) => {
  try {
    const { mobile } = req.body;
    const result = await otpService.resendOTP(mobile);
    res.status(200).json(result);
  } catch (error) {
    console.error('Error resending OTP:', error);
    res.status(500).json({ error: error.message });
  }
});

module.exports = router; 