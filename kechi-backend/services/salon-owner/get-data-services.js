const User = require('../../models/salon-owner/user');

async function getSalonOwnerByEmailOrPhone({ email, phone }) {
  if (!email && !phone) {
    throw new Error('Email or phone is required');
  }
  const query = email ? { email } : { phone };
  const user = await User.findOne(query).lean();
  if (!user) {
    throw new Error('User not found');
  }
  return user;
}

module.exports = {
  getSalonOwnerByEmailOrPhone
};


