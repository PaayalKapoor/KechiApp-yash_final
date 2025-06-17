const mongoose = require('mongoose');

const SalonOwnerSchema = new mongoose.Schema({
  salonId: { type: String, required: true, unique: true },
  salonName: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  phone: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  address: {
    line1: String,
    line2: String,
    pincode: String,
  },
  salonSlogan: { type: String, default: '' },
  description: { type: String, default: '' },
  category: { type: [String], default: [] },
  salonType: { 
    type: String, 
    enum: ['Male', 'Female', 'Unisex']
  },
  openingHour: { type: String, default: '' },
  hasMultipleBranches: { type: Boolean, default: false },
  hasMultipleStylists: { type: Boolean, default: false },
  latitude: { type: Number, default: null },
  longitude: { type: Number, default: null },
  aadharNumber: { 
    type: String, 
    validate: {
      validator: function(v) {
        return /^\d{12}$/.test(v);
      },
      message: props => `${props.value} is not a valid Aadhar number!`
    }
  },
  panNumber: { 
    type: String, 
    validate: {
      validator: function(v) {
        return /^[A-Z]{5}[0-9]{4}[A-Z]{1}$/.test(v);
      },
      message: props => `${props.value} is not a valid PAN number!`
    }
  },
  gstinNumber: { 
    type: String, 
    validate: {
      validator: function(v) {
        return /^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$/.test(v);
      },
      message: props => `${props.value} is not a valid GSTIN number!`
    }
  },
  documents: {
    aadharPdf: { type: String }, 
    panPdf: { type: String}, 
    gstinPdf: { type: String}, 
  },
  plan: { type: String, default: 'Free Trial' },
  startDate: { type: Date, default: Date.now },
  endDate: { type: Date, default: () => new Date(+new Date() + 14*24*60*60*1000) },
  isSubActive: { type: Boolean, default: true },
  isActive: { type: Boolean, default: true },
  createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('user', SalonOwnerSchema);
