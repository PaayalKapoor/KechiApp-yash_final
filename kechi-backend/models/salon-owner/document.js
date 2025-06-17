const mongoose = require('mongoose');

const DocumentSchema = new mongoose.Schema({
    filename: { type: String, required: true },
    contentType: { type: String, required: true },
    length: { type: Number, required: true },
    uploadDate: { type: Date, default: Date.now },
    metadata: {
        salonId: { type: String, required: true },
        documentType: { type: String, required: true, enum: ['aadhar', 'pan', 'gstin'] }
    }
});

module.exports = mongoose.model('Document', DocumentSchema);  