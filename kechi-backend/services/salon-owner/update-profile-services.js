const SalonOwner = require('../../models/salon-owner/user');

async function updateSalonOwnerProfile(salonId, updateData) {
  const salonOwner = await SalonOwner.findOne({ salonId });
  if (!salonOwner) {
    throw new Error('Salon owner not found');
  }
  Object.assign(salonOwner, updateData);
  return await salonOwner.save();
}

module.exports = {
  updateSalonOwnerProfile
};


