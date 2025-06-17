require('dotenv').config();
const express = require('express');
const cors = require('cors');
const mongoose = require('mongoose');
const { 
    salonOwnerSignupRouter, 
    salonOwnerSigninRouter, 
    salonOwnerUpdateProfileRouter, 
    salonOwnerGetDataRouter,
    salonOwnerUploadDocRouter 
} = require('./routes/salon-owner-routes');

const app = express();

// Middleware
app.use(cors({ origin: '*' }));
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

// Route imports
const otpRoutes = require('./routes/otpRoutes');

// Salon Owner Routes
app.use('/salonowner/signup', salonOwnerSignupRouter);
app.use('/salonowner/signin', salonOwnerSigninRouter);
app.use('/salonowner/profile', salonOwnerUpdateProfileRouter);
app.use('/salonowner/get', salonOwnerGetDataRouter);
app.use('/salonowner/documents', salonOwnerUploadDocRouter);

// OTP Routes
app.use('/otp', otpRoutes);

// Customer Routes


// Artist Routes


// Test routes
app.get('/test', (req, res) => {
    res.send('GET request to /test route');
});

// Export app
module.exports = app;
