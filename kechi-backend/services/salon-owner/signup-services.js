const SalonOwner = require('../../models/salon-owner/user');
const bcrypt = require('bcryptjs');

async function generateUniqueSalonId(salonName) {
  const prefix = `K${salonName.substring(0, 2).toUpperCase()}`;
  const regex = new RegExp(`^${prefix}\\d{3}$`);

  const existing = await SalonOwner.find({ salonId: { $regex: regex } }).sort({ salonId: -1 });
  
  let nextNumber = 1;
  if (existing.length > 0) {
    const lastSalonId = existing[0].salonId;
    const lastNumber = parseInt(lastSalonId.slice(-3));
    nextNumber = lastNumber + 1;
  }

  const paddedNumber = String(nextNumber).padStart(3, '0');
  return `${prefix}${paddedNumber}`;
}

async function registerSalonOwner(data) {
  const existing = await SalonOwner.findOne({
    $or: [{ email: data.email }, { phone: data.phone }]
  });
  if (existing) throw new Error('User already exists with email or phone');

  const hashedPassword = await bcrypt.hash(data.password, 10);
  const salonId = await generateUniqueSalonId(data.salonName);

  const newUser = new SalonOwner({
    salonId,
    salonName: data.salonName,
    email: data.email,
    phone: data.phone,
    password: hashedPassword,
    address: {
      line1: data.addressLine1,
      line2: data.addressLine2,
      pincode: data.pincode
    }
  });

  return await newUser.save();
}

module.exports = { registerSalonOwner };
