const express = require('express');
const multer = require('multer');
const upload = multer({ storage: multer.memoryStorage() });
const auth = require('../middleware/auth');

// Router declarations
const salonOwnerSignupRouter = express.Router();
const salonOwnerSigninRouter = express.Router();
const salonOwnerUpdateProfileRouter = express.Router();
const salonOwnerGetDataRouter = express.Router();
const salonOwnerUploadDocRouter = express.Router();

// Service imports
const signupService = require('../services/salon-owner/signup-services');
const signinService = require('../services/salon-owner/signin-services');
const updateProfileService = require('../services/salon-owner/update-profile-services');
const getDataService = require('../services/salon-owner/get-data-services');
const documentController = require('../controllers/salon-owner/document.controller');

//Signin Router
salonOwnerSignupRouter.post('/signup', async (req, res) => {
  try {
    const user = await signupService.registerSalonOwner(req.body);
    res.status(201).json({ message: 'Signup successful', user });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

//Signin Router
salonOwnerSigninRouter.post('/email', async (req, res) => {
  try {
    const { email, password } = req.body;
    const result = await signinService.loginSalonOwner({ email, password });
    res.status(200).json(result);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

// Google Sign-In route
salonOwnerSigninRouter.post('/google', async (req, res) => {
  try {
    const { email } = req.body;
    const result = await signinService.googleSignin(email);
    res.status(200).json(result);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

// Facebook Sign-In route
salonOwnerSigninRouter.post('/facebook', async (req, res) => {
  try {
    const { email } = req.body;
    const result = await signinService.facebookSignin(email);
    res.status(200).json(result);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

// Fetch salon owner by email or phone
salonOwnerGetDataRouter.get('/data', async (req, res) => {
  try {
    const { email, phone } = req.query;
    const user = await getDataService.getSalonOwnerByEmailOrPhone({ email, phone });
    res.status(200).json({ user });
  } catch (error) {
    res.status(404).json({ error: error.message });
  }
});

// Profile update route
salonOwnerUpdateProfileRouter.patch('/update', async (req, res) => {
  try {
    const { salonId, ...updateData } = req.body;
    if (!salonId) {
      return res.status(400).json({ message: 'Salon ID is required' });
    }
    const updatedSalonOwner = await updateProfileService.updateSalonOwnerProfile(salonId, updateData);
    res.status(200).json({ message: 'Profile updated successfully', data: updatedSalonOwner });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Document routes
salonOwnerUploadDocRouter.post('/upload', auth, upload.single('file'), documentController.uploadDocument);
salonOwnerUploadDocRouter.get('/file/:filename', auth, documentController.getDocument);
salonOwnerUploadDocRouter.delete('/file/:filename', auth, documentController.deleteDocument);
salonOwnerUploadDocRouter.get('/salon/:salonId', auth, documentController.getSalonDocuments);

// Export routers
module.exports = {
  salonOwnerSignupRouter,
  salonOwnerSigninRouter,
  salonOwnerUpdateProfileRouter,
  salonOwnerGetDataRouter,
  salonOwnerUploadDocRouter
};
