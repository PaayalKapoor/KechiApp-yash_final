const SalonOwner = require('../../models/salon-owner/user');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { jwtSecret } = require('../../config');
const { getSalonOwnerByEmailOrPhone } = require('./get-data-services');

async function loginSalonOwner({ email, password }) {
  const user = await SalonOwner.findOne({ email });
  if (!user) throw new Error('Invalid email');

  const isMatch = await bcrypt.compare(password, user.password);
  if (!isMatch) throw new Error('Invalid password');

  const token = jwt.sign(
    { id: user._id, role: 'salonowner' },
    jwtSecret,
    { expiresIn: '1d' }
  );

  return { token, user };
}

async function googleSignin(email) {
  if (!email) {
    throw new Error('Email is required');
  }
  const user = await getSalonOwnerByEmailOrPhone({ email });
  if (!user) {
    throw new Error('No account found. Please register first.');
  }
  const token = jwt.sign(
    { id: user._id, role: 'salonowner' },
    jwtSecret,
    { expiresIn: '1d' }
  );
  return { user, token };
}

async function facebookSignin(email) {
  if (!email) {
    throw new Error('Email is required');
  }
  const user = await getSalonOwnerByEmailOrPhone({ email });
  if (!user) {
    throw new Error('No account found. Please register first.');
  }
  const token = jwt.sign(
    { id: user._id, role: 'salonowner' },
    jwtSecret,
    { expiresIn: '1d' }
  );
  return { user, token };
}

module.exports = {
  loginSalonOwner,
  googleSignin,
  facebookSignin
};
